
extern "C" {
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
}
#include "qt_decompress.h"
#include "qt_decompress.cpp"

MODULE = LMMS::Parser PACKAGE = LMMS::Parser
PROTOTYPES: DISABLE

char* decompress(input)
	char* input
	CODE:
		RETVAL = decompress(input);
	OUTPUT:
		RETVAL
