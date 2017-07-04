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
#include <QtCore/QString>
#include <QtCore/QIODevice>
#include "qt_decompress.h"

char* decompress(char* filename) {

	QFile file(filename);
	file.open(QIODevice::ReadOnly);
	QByteArray bytes(file.readAll());
	file.close();
	

	printf("Length: %d\n",bytes.size());
	printf("First 2: %s\n",bytes.mid(0,2).data());
	if (bytes.size()<1) {
		return NULL;
	}
	return qUncompress(bytes).data();
}
