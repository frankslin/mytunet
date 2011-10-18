#!/bin/bash

qmake qtunet-mac.pro -spec macx-g++ -r CONFIG+=release
make
make pack
