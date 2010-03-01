#!/bin/sh

make

if [ ! "`ldd qtunet | grep "not found"`" = "" ]
then echo "Library requirement not satisfied."
	exit 1
fi

ldd -a qtunet | grep =\> | sort -u | sed 's/.* => //' | sed 's/ (0x.*)//' > libdep

if [ "${EDITOR}" = "" ]
then EDITOR=vim
fi

${EDITOR} libdep

echo qtunet >> libdep
echo qtunet_zh_CN.qm >> libdep
echo startqtunet >> libdep

VERSION=0.1

EXCLUDE_LIST="--exclude libc.so* \
	--exclude libm.so* \
	--exclude libgcc_s.so* \
	--exclude libz.so* \
	--exclude glibc.so* \
	--exclude libthr.so* \
	--exclude libicu*.so* \
	--exclude libX*.so* \
	--exclude libSM.so* \
	--exclude libiconv.so* \
	--exclude libintl.so* \
	--exclude libfontconfig.so* \
	--exclude libfreetype.so* \
	--exclude libstdc*.so* \
	--exclude libICE.so* "

tar Lzcvf qtunet-qt4-withlibs-`uname`-${VERSION}\.`svnversion -n | sed -e 's/[[:digit:]]*://g' | sed -e 's/M//g'`.tar.gz -T libdep ${EXCLUDE_LIST}
