# 编译运行 #

需要安装Qt4的开发包，用到了moc,uic,rcc,qmake，yum系可能在qt-devel或者qt4-devel包中。

下载源代码包，进入qtunet-qt4目录，运行Qt4的qmake，一般是 **qmake-qt4** 或者 **qmake** ，随后运行 **make** 。
也可以下载svn中的代码，checkout时请下载src子目录的内容。

之后运行 **make install** 进行安装， **make uninstall** 卸载。