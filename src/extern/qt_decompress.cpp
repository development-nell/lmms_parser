/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * main.cc
 * Copyright (C) 2017 Michael Hollenbeck <hollenbeck.ml@gmail.com>
 * 
 * QtCompress is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * QtCompress is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <iostream>
#include <QtCore/QByteArray>
#include <QtCore/QFile>
#include <QtCore/QFileInfo>
#include <QtCore/QString>
#include <QtCore/QIODevice>
#include "qt_decompress.h"
#include "MidiFile.h"


MidiFile midi;

char* decompress(char* filename) {

	QFile file(filename);
	file.open(QIODevice::ReadOnly);
	QByteArray bytes(file.readAll());
	file.close();

	if (bytes.size()<1) {
		return NULL;
	}

	QByteArray decompressed = qUncompress(bytes);
	QString output(decompressed);
	char* op = new char[output.size()+1];
	strcpy(op,output.toStdString().data());
	return op;
}

void newMidi(int tracks,int ticks,int tempo) {

	midi = MidiFile();
	midi.absoluteTicks();
	midi.addTrack(tracks);
	midi.setTicksPerQuarterNote(ticks);
}

void note(int track,int key,int velocity,int offset,int duration) {

	std::vector<uchar> note_on {(uchar)MIDI_NOTE_ON,(uchar)key,(uchar)velocity};
	midi.addEvent(track,offset,note_on);
	std::vector<uchar> note_off {(uchar)MIDI_NOTE_OFF,(uchar)key,0};
	midi.addEvent(track,offset+duration,note_off);

}

void saveMidi(char* filename) {
	
	midi.sortTracks();
	midi.write(filename);
}




	

	
