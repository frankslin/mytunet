# Microsoft Developer Studio Project File - Name="qtunet" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86)  Application" 0x0101

CFG=qtunet - Win32 Release
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "qtunet.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "qtunet.mak" CFG="qtunet - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "qtunet - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "qtunet - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "qtunet - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "tmp/obj"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "tmp/obj"
# PROP Target_Dir ""
# ADD CPP -MD /W3 /I "$(QTDIR)\include" /I "tmp\ui" /I "E:\SVNREP\MyTunet\qtunet" /I "E:\SVNREP\MyTunet\qtunet" /I "tmp\moc" /I "E:\Dev\Qt\3.3.2\mkspecs\win32-msvc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D UNICODE /D QT_DLL /D QT_THREAD_SUPPORT /D "QT_NO_DEBUG" /FD /c -nologo -Zm200 -GX -GX -GR -O1 
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BSC32 /nologo
LINK32=link.exe
# ADD LINK32  "qt-mt332.lib"  "qtmain.lib"  "kernel32.lib"  "user32.lib"  "gdi32.lib"  "comdlg32.lib"  "advapi32.lib"  "shell32.lib"  "ole32.lib"  "oleaut32.lib"  "uuid.lib"  "imm32.lib"  "winmm.lib"  "wsock32.lib"  "winspool.lib"  "kernel32.lib"  "user32.lib"  "gdi32.lib"  "comdlg32.lib"  "advapi32.lib"  "shell32.lib"  "ole32.lib"  "oleaut32.lib"  "uuid.lib"  "imm32.lib"  "winmm.lib"  "wsock32.lib"  "winspool.lib"  "opengl32.lib"  "glu32.lib"  "delayimp.lib"   /NOLOGO /SUBSYSTEM:windows /LIBPATH:"$(QTDIR)\lib" delayimp.lib /DELAYLOAD:comdlg32.dll /DELAYLOAD:oleaut32.dll /DELAYLOAD:winmm.dll /DELAYLOAD:wsock32.dll /DELAYLOAD:winspool.dll 


!ELSEIF  "$(CFG)" == "qtunet - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD CPP -MDd /W3 /GZ /ZI /Od /I "$(QTDIR)\include" /I "tmp\ui" /I "E:\SVNREP\MyTunet\qtunet" /I "E:\SVNREP\MyTunet\qtunet" /I "tmp\moc" /I "E:\Dev\Qt\3.3.2\mkspecs\win32-msvc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D UNICODE /D QT_DLL /D QT_THREAD_SUPPORT /FD /c -nologo -Zm200 -GX -GX -GR -Zi  
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BSC32 /nologo
LINK32=link.exe
# ADD LINK32  "qt-mt332.lib"  "qtmain.lib"  "kernel32.lib"  "user32.lib"  "gdi32.lib"  "comdlg32.lib"  "advapi32.lib"  "shell32.lib"  "ole32.lib"  "oleaut32.lib"  "uuid.lib"  "imm32.lib"  "winmm.lib"  "wsock32.lib"  "winspool.lib"  "kernel32.lib"  "user32.lib"  "gdi32.lib"  "comdlg32.lib"  "advapi32.lib"  "shell32.lib"  "ole32.lib"  "oleaut32.lib"  "uuid.lib"  "imm32.lib"  "winmm.lib"  "wsock32.lib"  "winspool.lib"  "opengl32.lib"  "glu32.lib"  "delayimp.lib"   /NOLOGO /SUBSYSTEM:windows /LIBPATH:"$(QTDIR)\lib" /pdbtype:sept /DEBUG 


!ENDIF 

# Begin Target

# Name "qtunet - Win32 Release"
# Name "qtunet - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=main.cpp
# End Source File
# Begin Source File

SOURCE=..\des.c
# End Source File
# Begin Source File

SOURCE=..\dot1x.c
# End Source File
# Begin Source File

SOURCE=..\tunet.c
# End Source File
# Begin Source File

SOURCE=..\mytunetsvc.c
# End Source File
# Begin Source File

SOURCE=..\mytunet.c
# End Source File
# Begin Source File

SOURCE=..\ethcard_eth.c
# End Source File
# Begin Source File

SOURCE=..\ethcard_bpf.c
# End Source File
# Begin Source File

SOURCE=..\logs.c
# End Source File
# Begin Source File

SOURCE=..\ethcard_win.c
# End Source File
# Begin Source File

SOURCE=..\md5.c
# End Source File
# Begin Source File

SOURCE=..\os.c
# End Source File
# Begin Source File

SOURCE=..\os_posix.c
# End Source File
# Begin Source File

SOURCE=..\os_win32.c
# End Source File
# Begin Source File

SOURCE=..\setting.c
# End Source File
# Begin Source File

SOURCE=..\userconfig.c
# End Source File
# Begin Source File

SOURCE=..\util.c
# End Source File
# Begin Source File

SOURCE=qtunet.cpp
# End Source File
# Begin Source File

SOURCE=dlg_main.ui.h
# End Source File
# Begin Source File

SOURCE=dlg_about.ui.h
# End Source File

# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=qtunet.h

USERDEP_qtunet=""$(QTDIR)\bin\moc.exe""

!IF  "$(CFG)" == "qtunet - Win32 Release"

# Begin Custom Build - Moc'ing qtunet.h...
InputPath=.\qtunet.h


BuildCmds= \
	$(QTDIR)\bin\moc qtunet.h -o tmp\moc\moc_qtunet.cpp \

"tmp\moc\moc_qtunet.cpp" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
   $(BuildCmds)

# End Custom Build

!ELSEIF  "$(CFG)" == "qtunet - Win32 Debug"

# Begin Custom Build - Moc'ing qtunet.h...
InputPath=.\qtunet.h


BuildCmds= \
	$(QTDIR)\bin\moc qtunet.h -o tmp\moc\moc_qtunet.cpp \

"tmp\moc\moc_qtunet.cpp" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
   $(BuildCmds)

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=..\des.h

# End Source File
# Begin Source File

SOURCE=..\dot1x.h

# End Source File
# Begin Source File

SOURCE=..\tunet.h

# End Source File
# Begin Source File

SOURCE=..\mytunetsvc.h

# End Source File
# Begin Source File

SOURCE=..\mytunet.h

# End Source File
# Begin Source File

SOURCE=..\ethcard.h

# End Source File
# Begin Source File

SOURCE=..\logs.h

# End Source File
# Begin Source File

SOURCE=..\md5.h

# End Source File
# Begin Source File

SOURCE=..\os.h

# End Source File
# Begin Source File

SOURCE=..\setting.h

# End Source File
# Begin Source File

SOURCE=..\userconfig.h

# End Source File
# Begin Source File

SOURCE=..\util.h

# End Source File

# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# End Group

# Begin Group "Forms"
# Prop Default_Filter "ui"
# Begin Source File

SOURCE=dlg_main.ui
USERDEP_dlg_main.ui="$(QTDIR)\bin\moc.exe" "$(QTDIR)\bin\uic.exe"

!IF  "$(CFG)" == "qtunet - Win32 Release"

# Begin Custom Build - Uic'ing dlg_main.ui...
InputPath=.\dlg_main.ui

BuildCmds= \
	$(QTDIR)\bin\uic dlg_main.ui -o tmp\ui\dlg_main.h \
	$(QTDIR)\bin\uic dlg_main.ui -i dlg_main.h -o tmp\ui\dlg_main.cpp \
	$(QTDIR)\bin\moc  tmp\ui\dlg_main.h -o tmp\moc\moc_dlg_main.cpp \

"tmp\ui\dlg_main.h" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

"tmp\ui\dlg_main.cpp" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

"tmp\moc\moc_dlg_main.cpp" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

# End Custom Build

!ELSEIF  "$(CFG)" == "qtunet - Win32 Debug"

# Begin Custom Build - Uic'ing dlg_main.ui...
InputPath=.\dlg_main.ui

BuildCmds= \
	$(QTDIR)\bin\uic dlg_main.ui -o tmp\ui\dlg_main.h \
	$(QTDIR)\bin\uic dlg_main.ui -i dlg_main.h -o tmp\ui\dlg_main.cpp \
	$(QTDIR)\bin\moc  tmp\ui\dlg_main.h -o tmp\moc\moc_dlg_main.cpp \

"tmp\ui\dlg_main.h" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

"tmp\ui\dlg_main.cpp" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

"tmp\moc\moc_dlg_main.cpp" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=dlg_about.ui
USERDEP_dlg_about.ui="$(QTDIR)\bin\moc.exe" "$(QTDIR)\bin\uic.exe"

!IF  "$(CFG)" == "qtunet - Win32 Release"

# Begin Custom Build - Uic'ing dlg_about.ui...
InputPath=.\dlg_about.ui

BuildCmds= \
	$(QTDIR)\bin\uic dlg_about.ui -o tmp\ui\dlg_about.h \
	$(QTDIR)\bin\uic dlg_about.ui -i dlg_about.h -o tmp\ui\dlg_about.cpp \
	$(QTDIR)\bin\moc  tmp\ui\dlg_about.h -o tmp\moc\moc_dlg_about.cpp \

"tmp\ui\dlg_about.h" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

"tmp\ui\dlg_about.cpp" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

"tmp\moc\moc_dlg_about.cpp" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

# End Custom Build

!ELSEIF  "$(CFG)" == "qtunet - Win32 Debug"

# Begin Custom Build - Uic'ing dlg_about.ui...
InputPath=.\dlg_about.ui

BuildCmds= \
	$(QTDIR)\bin\uic dlg_about.ui -o tmp\ui\dlg_about.h \
	$(QTDIR)\bin\uic dlg_about.ui -i dlg_about.h -o tmp\ui\dlg_about.cpp \
	$(QTDIR)\bin\moc  tmp\ui\dlg_about.h -o tmp\moc\moc_dlg_about.cpp \

"tmp\ui\dlg_about.h" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

"tmp\ui\dlg_about.cpp" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

"tmp\moc\moc_dlg_about.cpp" : "$(SOURCE)" "$(INTDIR)" "$(OUTDIR)"
	$(BuildCmds)

# End Custom Build

!ENDIF 

# End Source File

# End Group






# Begin Group "Generated"
# Begin Source File

SOURCE=tmp\moc\moc_qtunet.cpp
# End Source File
# Begin Source File

SOURCE=tmp\moc\moc_dlg_main.cpp
# End Source File
# Begin Source File

SOURCE=tmp\moc\moc_dlg_about.cpp
# End Source File

# Begin Source File

SOURCE=tmp\ui\dlg_main.cpp
# End Source File
# Begin Source File

SOURCE=tmp\ui\dlg_about.cpp
# End Source File

# Begin Source File

SOURCE=tmp\ui\dlg_main.h
# End Source File
# Begin Source File

SOURCE=tmp\ui\dlg_about.h
# End Source File




# Prop Default_Filter "moc"
# End Group
# End Target
# End Project

