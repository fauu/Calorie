#!/bin/bash

sudo rm -rf build/
mkdir build/
cd build/
cmake -DCMAKE_INSTALL_PREFIX=install ../
make
sudo make install
./install/bin/calorie
