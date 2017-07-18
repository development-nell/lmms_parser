use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
	module_name    => 'LMMS::Parser',
   	license        => 'perl',
   	dist_author    => ['Michael Hollenbeck Crabcakes'],
	dist_version_from => "lib/LMMS/Parser.pm",
   	needs_compiler => 1,
   	configure_requires => {
   		'Config::AutoConf'   => '0.14',
   		'ExtUtils::CBuilder' => '0.27',
   		'ExtUtils::LibBuilder' => '0.01',
   		'Module::Build'      => '0.3603',
   	},
	requires => {
    	'Moo'=>0,
		'XML::TreeBuilder'=>0,
		'File::Util'=>0,
	},
	libdir   => "./lib",
    extra_compiler_flags => '-I/usr/include/qt4', 
	extra_linker_flags=>[qw(-lQtCore)],

	config=>{cc => 'g++', ld => 'g++'},
    include_dirs => [qw(../src/extern ../src/midifile)],
    c_source     => ['../src/'],
);
$builder->create_build_script();
