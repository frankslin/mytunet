# File generated by kdevelop''s qmake manager. 
# ------------------------------------------- 
# Subdir relative project main directory: .
# Target is ????? 

LANGUAGE = C++ 
MOC_DIR = tmp/moc 
UI_DIR = tmp/ui 
OBJECTS_DIR = tmp/obj 
CONFIG += debug \
          warn_on \
          qt \
          thread \
          x11 
TEMPLATE = app 
FORMS += dlg_main.ui \
         dlg_about.ui 
HEADERS += qtunet.h \
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
		   main.h
SOURCES += main.cpp \
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
           qtunet.cpp
TRANSLATIONS =  \
                i18n/qtunet_zh_CN.ts
COMPILED_TRANSLATIONS = i18n/qtunet_zh_CN.qm
INSTALL_PREFIX = /usr/local
DATADIR = $$INSTALL_PREFIX/share/qtunet
TRANSLATION_DIR = $$DATADIR/lang
DEFINES += TRANSLATION_DIR=\\\"$$TRANSLATION_DIR\\\"
DISTFILES += qtunet # qtunet_zh_CN.qm
target.path = $$INSTALL_PREFIX/bin
# translation.files = qtunet_zh_CN.qm
# translation.path = $$TRANSLATION_DIR
INSTALLS += target # translation
RESOURCES += icons.qrc i18n.qrc
unix{
  DEFINES += _POSIX
  DEFINES += POSIX
}
freebsd-* :message("FreeBSD platform"){
  DEFINES += _BSD
}
linux-* :message("Linux platform") {
  DEFINES += _LINUX
}
macx-* :message("Mac OS X platform") {
  DEFINES += _BSD _MACOSX
}
VERSION = 0.1
pack.target = pack
pack.commands = strip qtunet; tar zcvf qtunet-qt4-`uname`-$$VERSION\.`svnversion -n | sed -e 's/[[:digit:]]*://g' | sed -e 's/M//g'`.tar.gz $$DISTFILES
pack.depends = qtunet
QMAKE_EXTRA_TARGETS += pack

