# -------------------------------------------------
# Project created by QtCreator 2011-10-18T08:31:49
# -------------------------------------------------
TARGET = qtunet-mac
CONFIG += qt \
    i386 \
    thread \
    release
MOC_DIR = tmp/moc
UI_DIR = tmp/ui
OBJECTS_DIR = tmp/obj
RCC_DIR = tmp/rcc
ICON = qtunet-mac.icns
TEMPLATE = app
HEADERS += ../qtunet-qt4/qtunet.h \
    ../des.h \
    ../dot1x.h \
    ../tunet.h \
    ../mytunetsvc.h \
    ../mytunet.h \
    ../ethcard.h \
    ../logs.h \
    ../md5.h \
    ../os.h \
    ../setting.h \
    ../userconfig.h \
    ../util.h \
    ../qtunet-qt4/main.h
SOURCES += ../qtunet-qt4/main.cpp \
    ../des.c \
    ../dot1x.c \
    ../tunet.c \
    ../mytunetsvc.c \
    ../mytunet.c \
    ../ethcard_eth.c \
    ../ethcard_bpf.c \
    ../logs.c \
    ../ethcard_win.c \
    ../md5.c \
    ../os.c \
    ../os_posix.c \
    ../os_win32.c \
    ../setting.c \
    ../userconfig.c \
    ../util.c \
    ../qtunet-qt4/qtunet.cpp
FORMS += ../qtunet-qt4/dlg_main.ui \
    ../qtunet-qt4/dlg_about.ui
TRANSLATIONS = ../qtunet-qt4/i18n/qtunet_zh_CN.ts
COMPILED_TRANSLATIONS = ../qtunet-qt4/i18n/qtunet_zh_CN.qm
unix { 
    DEFINES += _POSIX
    DEFINES += POSIX
}
freebsd-*:message("FreeBSD platform"):DEFINES += _BSD
linux-*:message("Linux platform"):DEFINES += _LINUX
macx-*:message("Mac OS X platform"):DEFINES += _BSD \
    _MACOSX
RESOURCES += ../qtunet-qt4/icons.qrc \
    ../qtunet-qt4/i18n.qrc
VERSION = 0.1
pack.target = pack
pack.commands = macdeployqt qtunet-mac.app/
pack.depends = all
QMAKE_EXTRA_TARGETS += pack
