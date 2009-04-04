OBJS = main.o \
	../../des.o \
	../../dot1x.o \
	../../ethcard_bpf.o \
	../../ethcard_eth.o \
	../../ethcard_win.o \
	../../logs.o \
	../../md5.o \
	../../mytunet.o \
	../../mytunetsvc.o \
	../../os.o \
	../../os_posix.o \
	../../os_win32.o \
	../../setting.o \
	../../tunet.o \
	../../userconfig.o \
	../../util.o

# Install prefix
PREFIX = /usr/local
CC = gcc
CPP = g++

CFLAGS = -D_POSIX -DPOSIX
LDFLAGS = -pthread
OSX_CFLAGS = -D_BSD -DMACOSX -arch ppc -arch i386
LINUX_CFLAGS = -D_LINUX
BSD_CFLAGS = -D_BSD

# Modify according to your platform
CFLAGS += ${BSD_CFLAGS}
# CFLAGS += ${OSX_CFLAGS}
# CFLAGS += ${LINUX_CFLAGS}

all: mytunet

mytunet: ${OBJS}
	${CC} ${CFLAGS} ${LDFLAGS} ${OBJS} -o mytunet

.c.o:
	${CC} ${CFLAGS} -c $< -o $@

%.o: %.c
	${CC} ${CFLAGS} -c $< -o $@

.PHONY: clean install uninstall
clean:
	rm -f mytunet ${OBJS}

install:
	install -m 755 mytunet ${PREFIX}/bin

uninstall:
	rm -f ${PREFIX}/bin/mytunet

