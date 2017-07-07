package LMMS::Parser;

use strict;
use Modern::Perl;
use Moo;
use XSLoader;
use XML::TreeBuilder;
use File::Util;
use Data::Dumper;
use File::Basename qw(basename);

our $VERSION = "0.0.1";
our $ABSTRACT = "Parse project files from the open-source DAW LMMS";

use constant MIDI_CLOCK_BEAT=>24;

XSLoader::load("LMMS::Parser",$VERSION);

has tracks=>(is=>'rw',default=>sub {[];});
has song=>(is=>'rw',default=>sub {{};});
has tree=>(is=>'rw');

sub BUILD {
	my ($self,$args) = @_;

	if ($args->{file}) {
		$self->load($args->{file});
	}
}


sub load {
	my ($self,$path) = @_;

	my $fu = File::Util->new();
	my $contents;
	
	if ($path=~/mmpz$/i) {
		$contents = LMMS::Parser::decompress($path);
	} else {
		$contents = $fu->load_file($path);
	}

	open(FO,">",basename($path).".xml");
	print FO $contents;
	close(FO);

	my $tree = XML::TreeBuilder->new();
	$tree->parse($contents);

	my $header = $tree->look_down(_tag=>"head");
	my $song = {
		bpm=>$header->attr("bpm"),
		numerator=>$header->attr("timesig_numerator"),
		denominator=>$header->attr("timesig_denominator"),
		offset=>0,
		ticks_per_beat=>480,
	};
	
	if (!$song->{bpm}) { #somtimes it's here for some reason idk
		$song->{bpm} = $header->look_down(_tag=>"bpm")->attr("value");
		$song->{numerator} = $header->look_down(_tag=>"timesig_numerator")->attr("value");
		$song->{denominator} = $header->look_down(_tag=>"timesig_denominator")->attr("value");
	}

	$song->{tempo} = int(60_000_000/$song->{bpm});
	# LMMS seems to use a tick 
	$song->{lmms_ticks_per_beat} = ($song->{numerator}/(($song->{denominator}/2))*MIDI_CLOCK_BEAT);
	$song->{tick_multiplier} = int($song->{ticks_per_beat}/$song->{lmms_ticks_per_beat});
	
	
	my @tracks;


	TRACKLOOP: foreach my $track_data ($tree->look_down(_tag=>'track')) {
		next if ($track_data->attr("muted"));
		my $instrument_header = $track_data->look_down(_tag=>"instrumenttrack");
		next TRACKLOOP if (!$instrument_header);
		my @patterns = $track_data->look_down(_tag=>"pattern");
		if (scalar(@patterns) && $patterns[0]->is_empty) {
			next TRACKLOOP;
		}
		my $track = {
			name=>$track_data->attr('name'),
			track=>scalar(@tracks)+1,
			pan=>$instrument_header->attr('pan'),
			pitch=>$instrument_header->attr('pitch'),
			volume=>$instrument_header->attr('vol'),
		};
		my @events;
		foreach my $pattern (sort {$a->attr("pos")<=>$b->attr("pos")} @patterns) {
			my $offset = $pattern->attr("pos")*$song->{tick_multiplier};
			foreach my $note ($pattern->look_down(_tag=>"note")) {
				my $event = {
					offset=>($note->attr("pos")*$song->{tick_multiplier})+$offset,#*($offset*$song->{tick_multiplier}),
					velocity=>(($note->attr("vol")/100)*($track->{volume}/100))*127,
					key=>$note->attr("key"),
					pan=>$note->attr("pan"),
					duration=>$note->attr("len")*$song->{tick_multiplier},
					ticks=>int($song->{ticks_per_beat}*($note->attr("len")/$song->{lmms_ticks_per_beat})),
				};
				push(@events,$event);
			}
		}
		next if (!scalar(@events));
		$track->{events} = [@events];
		push(@tracks,$track);
	}
	$song->{tracks} = [@tracks];
	$self->song($song);
}

sub writemidi {
	my ($self,%args) = @_;

	


}

sub event {
	my ($self,$events,$offset,%args) = @_;

	say "adding $args{event} at $offset";

	$events->{$offset}||=[];
	push(@{$events->{$offset}},{%args});
	say Dumper($events);
}
		
	
1;
