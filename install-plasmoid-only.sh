#!/bin/sh

# Remove the build directory if it exists
if [ -d "build" ]; then
    rm -rf build
fi

# Create a new build directory
mkdir build
cd build

# install plasmoid only
cmake cmake -DBUILD_PLUGIN=OFF -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..

# Build the project
make

# Install the built project
sudo make install
