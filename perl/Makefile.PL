use 5.008005;
use ExtUtils::MakeMaker 7.12; # for XSMULTI option
use FindBin;


WriteMakefile(
  	NAME           => 'LMMS::Parser',
  	VERSION_FROM   => 'lib/LMMS/Parser.pm',
  	PREREQ_PM      => {
		'ExtUtils::MakeMaker' => '7.12',
		'XML::TreeBuilder'=>0,
		'Moo'=>0,
 	},
 	ABSTRACT_FROM  => 'lib/LMMS/Parser.pm',
 	AUTHOR         => 'Michael Hollenbeck (hollenbeck.ml@gmail.com)',
 	CCFLAGS        => '-D_REENTRANT -D_GNU_SOURCE -DDEBIAN -fwrapv -fno-strict-aliasing -pipe -I/usr/local/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -Wall -Wextra -Wno-unused-parameter -o $*.a',#o -I../src -fPIC -D_REENTRANT -D_GNU_SOURCE -pipe -D_GNU_SOURCE -DDEBIAN -fwrapv -fno-strict-aliasing -pipe -I/usr/local/include/qt4 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -Wall -Wextra -Wno-unused-parameter -o $*.o',
 	LIBS			=> ' -lQtCore -lpthreads',
 	LICENSE        => 'unlicensed',
	TYPEMAPS		=>["./typemap"],
	#"EXE_FILES"	=>["scripts/goatify"],
	"INC"			=> "-I./inc -I$FindBin::Bin/../src -I/usr/include/qt4",
	dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	XSOPT => '-C++',
	XSMULTI => 1,
	LD	=> '$(CC)',
	CC	=> 'g++',
	OPTIMIZE=>'-O3',
	OBJECT            => '../src/qt_decompress.o $(O_FILES)',
	C				=> ['../src/qt_decompress.cpp'],
	
);
