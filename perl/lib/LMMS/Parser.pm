package LMMS::Parser;

use strict;
use Modern::Perl;
use Moo;
use XSLoader;
use XML::TreeBuilder;
use File::Util;

our $VERSION = "0.0.1";
our $ABSTRACT = "Parse project files from the open-source DAW LMMS";

XSLoader::load("LMMS::Parser",$VERSION);

has tracks=>(is=>'rw',default=>sub {[];});
has tree=>(is=>'rw');


sub load {
	my ($self,$path) = @_;

	my $fu = File::Util->new();
	my $contents;
	
	if ($path=~/mmpz$/i) {
		$contents = LMMS::Parser::decompress($path);
	} else {
		$contents = $fu->load_file($path);
	}
	say $contents;
	#$self->tree(XML::TreeBuilder->new_from_content($contents));
}
	
1;
