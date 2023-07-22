#!/bin/sh

# Remove the build directory if it exists
if [ -d "build" ]; then
    rm -rf build
fi

# Create a new build directory
mkdir build
cd build

# build plugin only
cmake cmake -DBUILD_PLASMOID=OFF -DINSTALL_PLASMOID=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ..

# Build the plasmoid file
make plugin

sudo make install