# Introduction #

本文说明如何使用Qtunet。
下文中，_(版本号)_均指代最新版本Qtunet的版本号，具体内容可能会随时间变化。

# Details #

**FreeBSD**

下载qtunet-qt4-FreeBSD-_(版本号)_.tar.gz

下载qt4-libs-4.6.1-FreeBSD.tar.bz2

解压缩到同一个目录，
在其中运行./startqtunet

**新版Linux**

一般情况下，如下操作：

下载qtunet-qt4-Linux-_(版本号)_.tar.gz

下载qt4-libs-4.6.2-Linux.tar.bz2

解压缩到同一个目录，
在其中运行 ./startqtunet

**旧版Linux**

如果提示

./qtunet: /lib/libc.so.6: version `GLIBC\_2.9' not found (required by ./libQtGui.so.4)

./qtunet: /lib/libc.so.6: version `GLIBC\_2.9' not found (required by ./libQtCore.so.4)

那么Linux版本比较老，如下操作：

下载qtunet-qt4-Linux-legacy-_(版本号)_.tar.gz

下载qt4-libs-4.2.1-Linux.tar.bz2

解压缩到同一个目录，
在其中运行 ./startqtunet