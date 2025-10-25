include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMQmlModule)

ecm_add_qml_module(quicklaunchplugin URI luisbocanegra.panelspacer.extended.quicklaunch)
target_sources(quicklaunchplugin PRIVATE
    quicklaunch_p.cpp
    quicklaunchplugin.cpp
)

find_package(Qt6 ${QT_MIN_VERSION} CONFIG REQUIRED
    Core
    Qml
)

find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS
    KIO
    Notifications
)

target_link_libraries(quicklaunchplugin PRIVATE
    Qt::Core
    Qt::Qml
    KF6::KIOCore
    KF6::KIOWidgets
    KF6::Notifications
)
ecm_finalize_qml_module(quicklaunchplugin)
