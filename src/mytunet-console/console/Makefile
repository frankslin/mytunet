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

PREFIX = /usr/local
CC = gcc
CPP = g++

CFLAGS = -D_BSD -D_POSIX -DPOSIX
LDFLAGS = -pthread

all: mytunet

mytunet: ${OBJS}
	${CC} ${CFLAGS} ${LDFLAGS} ${OBJS} -o mytunet

MAKEOBJDIR = ../../

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

