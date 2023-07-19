cmake_minimum_required(VERSION 3.16)
project(plasmoid-spacer-extended)

# Use Extra CMake Modules (ECM) for common functionality.
# See http://api.kde.org/ecm/manual/ecm.7.html
# and http://api.kde.org/ecm/manual/ecm-kde-modules.7.html
find_package(ECM REQUIRED NO_MODULE)
# Needed by find_package(KF5Plasma) below.
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_MODULE_PATH})

# Locate plasma_install_package macro.
find_package(KF5Plasma REQUIRED)

# User installation
#set(CMAKE_INSTALL_PREFIX "$ENV{HOME}/.local")

plasma_install_package(package luisbocanegra.panelspacer.extended)

add_subdirectory(plugin)
