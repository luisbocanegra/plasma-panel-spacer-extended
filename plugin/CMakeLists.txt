cmake_minimum_required(VERSION 3.16)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_MODULE_PATH})

set(KF5_MIN_VERSION "5.102.0")
set(KDE_COMPILERSETTINGS_LEVEL "5.82")

# Use Extra CMake Modules (ECM) for common functionality.
# See http://api.kde.org/ecm/manual/ecm.7.html
# and http://api.kde.org/ecm/manual/ecm-kde-modules.7.html

find_package(ECM ${KF5_MIN_VERSION} REQUIRED NO_MODULE)
# Needed by find_package(KF5Plasma) below.
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS I18n PlasmaQuick)

# Locate plasma_install_package macro.
find_package(KF5Plasma REQUIRED)

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

kde_enable_exceptions()

add_definitions(-DTRANSLATION_DOMAIN=\"panelspacer\")

kcoreaddons_add_plugin(luisbocanegra.panelspacer.extended SOURCES panelspacer.cpp panelspacer.h INSTALL_NAMESPACE "plasma/applets")

target_link_libraries(luisbocanegra.panelspacer.extended Qt::Gui Qt::Core Qt::Qml Qt::Quick KF5::Plasma KF5::PlasmaQuick KF5::I18n)
