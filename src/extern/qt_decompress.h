#ifndef _DECOMPRESS
#define _DECOMPRESS
#define MIDI_NOTE_ON 0x90
#define MIDI_NOTE_OFF 0x80


char* decompress (char* contents);
void newMidi(int tracks,int ticks,int tempo);
void note(int track,int key,int velocity,int start,int len);
void saveMidi(char* filename);
#endif

