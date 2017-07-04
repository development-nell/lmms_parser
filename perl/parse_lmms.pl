#!/usr/bin/perl

use XML::TreeBuilder;
use Modern::Perl;
use Data::Dumper;
use LMMS::Parser;

my $parser = LMMS::Parser->new();
$parser->load("../assets/sample.mmpz");
