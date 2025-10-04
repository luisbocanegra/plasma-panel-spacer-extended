#!/bin/sh

# Remove the build directory if it exists
if [ -d "build" ]; then
    rm -rf build
fi

# Install widget for current user
cmake -B build -S . -DBUILD_PLUGIN=OFF -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build build
cmake --install build

# cmake plasma_install_package does't copy executable permission
chmod 700 "$HOME/.local/share/plasma/plasmoids/luisbocanegra.panelspacer.extended/contents/ui/tools/get_shortcuts.sh"
chmod 700 "$HOME/.local/share/plasma/plasmoids/luisbocanegra.panelspacer.extended/contents/ui/tools/run_kwin_script.sh"
