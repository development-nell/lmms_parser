
extern "C" {
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
}

#include "qt_decompress.h"


MODULE = LMMS::Parser PACKAGE = LMMS::Parser
PROTOTYPES: DISABLE

const char* decompress(input)
	char* input
	CODE:
		RETVAL = decompress(input);
	OUTPUT:
		RETVAL

void* newMidi(caller,tracks,ticks,tempo)
	SV* caller
	int tracks
	int ticks
	int tempo
	CODE:
		newMidi(tracks,ticks,tempo);

void* note(caller,track,key,velocity,start,len)
	SV* caller
	int track
	int key
	int velocity
	int start
	int len
	CODE:
		note(track,key,velocity,start,len);

void* saveMidi(caller,filename)
	SV* caller
	char* filename
	CODE:
		saveMidi(filename);
