#!/bin/sh

tar -jcvf qt4-libs-`qmake-qt4 -query QT_VERSION`-`uname`.tar.bz2 libQtGui.so.4 libQtCore.so.4 codecs/libqcncodecs.so startqtunet README.libs
