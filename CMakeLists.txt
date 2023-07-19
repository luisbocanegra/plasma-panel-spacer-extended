cmake_minimum_required(VERSION 3.16)
project(plasmoid-spacer-extended)
option(BUILD_PLUGIN "Build the plugin" ON)
option(INSTALL_PLASMOID "Install the plasmoid" ON)
option(BUILD_PLASMOID "Build the plasmoid file" ON)
# Use Extra CMake Modules (ECM) for common functionality.
# See http://api.kde.org/ecm/manual/ecm.7.html
# and http://api.kde.org/ecm/manual/ecm-kde-modules.7.html
find_package(ECM REQUIRED NO_MODULE)
# Needed by find_package(KF5Plasma) below.
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_MODULE_PATH})

if(INSTALL_PLASMOID)
    # Locate plasma_install_package macro.
    find_package(KF5Plasma REQUIRED)

    # User installation
    #set(CMAKE_INSTALL_PREFIX "$ENV{HOME}/.local")

    plasma_install_package(package luisbocanegra.panelspacer.extended)
endif()

# Genreate plasmoid file
set(PLASMOID_FILE "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}.plasmoid")

add_custom_target(plasmoid
    COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_SOURCE_DIR}/package zip -r ${PLASMOID_FILE} ./
    COMMENT "Generating ${PLASMOID_FILE}"
)

if(BUILD_PLUGIN)
    add_subdirectory(plugin)
endif()

add_custom_target(plugin
    COMMAND ${CMAKE_COMMAND} --build plugin
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)