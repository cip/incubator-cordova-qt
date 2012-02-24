# Add files and directories to ship with the application
# by adapting the examples below.
# file1.source = myfile
# dir1.source = mydir
wwwDir.source = www
xmlDir.source = xml


SOURCES += main.cpp \
    src/plugins/notification.cpp \
    src/plugins/geolocation.cpp \
    src/plugins/fileapi.cpp \
    src/plugins/device.cpp \
    src/pluginregistry.cpp \
    src/plugins/console.cpp \
    src/plugins/connection.cpp \
    src/plugins/compass.cpp \
    src/plugins/accelerometer.cpp \
    src/plugins/events.cpp \
    src/cordova.cpp \
    src/cplugin.cpp
HEADERS += \
    src/plugins/notification.h \
    src/plugins/geolocation.h \
    src/plugins/fileapi.h \
    src/plugins/device.h \
    src/pluginregistry.h \
    src/plugins/console.h \
    src/plugins/connection.h \
    src/plugins/compass.h \
    src/plugins/accelerometer.h \
    src/plugins/events.h \
    src/cordova.h \
    src/cplugin.h

#QML (Common)
common_qml.source = qml/common/cordova
common_qml.target = qml

greaterThan(QT_MAJOR_VERSION, 4) {
    message("Qt5 build")
    QT += widgets
    QT += location
    QT += sensors
    QT += feedback
    QT += systeminfo
    QT += quick declarative
    #TODO distinguish between harmattan and normal qt5
    platform_qml.source = qml/qt5/cordova
    platform_qml.target = qml
} else:!isEmpty(MEEGO_VERSION_MAJOR) {
    message("Qt4 build")
    message("Harmattan build")

    OTHER_FILES += qml/main_harmattan.qml \
        qml/cordova_wrapper.js

    QT += declarative
    CONFIG += mobility qdeclarative-boostable
    MOBILITY += feedback location systeminfo sensors
    # QML (Harmattan components) related
    platform_qml.source = qml/harmattan/cordova
    platform_qml.target = qml
} else:symbian {
    message("Qt4 build")
    message("Symbian build")
    # QML (Symbian components) related
    platform_qml.source = qml/symbian/cordova
    platform_qml.target = qml

    symbian:TARGET.UID3 = 0xE3522943
    #symbian:DEPLOYMENT.installer_header = 0x2002CCCF
    symbian:TARGET.CAPABILITY += NetworkServices Location

    QT += declarative

    # Add dependency to Symbian components
    CONFIG += qt-components

    CONFIG += mobility
    MOBILITY += feedback location systeminfo sensors
} else {
    message("Qt4 build")
    message("Non-harmattan build")

    OTHER_FILES += qml/main.qml \
        qml/cordova_wrapper.js

    QT += declarative

    CONFIG += mobility
    MOBILITY += feedback location systeminfo sensors
}
DEPLOYMENTFOLDERS = common_qml platform_qml wwwDir xmlDir

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

QT += webkit

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog
