# Microsoft Developer Studio Project File - Name="MyTunetSvc" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=MyTunetSvc - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "MyTunetSvc.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "MyTunetSvc.mak" CFG="MyTunetSvc - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "MyTunetSvc - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "MyTunetSvc - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "MyTunetSvc - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "MyTunetSvc___Win32_Release"
# PROP BASE Intermediate_Dir "MyTunetSvc___Win32_Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "SvcRelease"
# PROP Intermediate_Dir "SvcRelease"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Yu"stdafx.h" /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /FR /FD /c
# SUBTRACT CPP /YX /Yc /Yu
# ADD BASE RSC /l 0x804 /d "NDEBUG"
# ADD RSC /l 0x804 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386 /out:"VBGUI/Svc/MyTunetSvc.exe"
# Begin Special Build Tool
SOURCE="$(InputPath)"
PostBuild_Cmds=copy /y VBGUI\Svc\MyTunetSvc.exe VBGUI\Release\Svc\MyTunetSvc.exe
# End Special Build Tool

!ELSEIF  "$(CFG)" == "MyTunetSvc - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "MyTunetSvc___Win32_Debug"
# PROP BASE Intermediate_Dir "MyTunetSvc___Win32_Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "SvcDebug"
# PROP Intermediate_Dir "SvcDebug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Yu"stdafx.h" /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /FR /FD /GZ /c
# SUBTRACT CPP /YX /Yc /Yu
# ADD BASE RSC /l 0x804 /d "_DEBUG"
# ADD RSC /l 0x804 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /out:"VBGUI/Svc/MyTunetSvc.exe" /pdbtype:sept
# Begin Special Build Tool
SOURCE="$(InputPath)"
PostBuild_Cmds=copy /y VBGUI\Svc\MyTunetSvc.exe VBGUI\Release\Svc\MyTunetSvc.exe
# End Special Build Tool

!ENDIF 

# Begin Target

# Name "MyTunetSvc - Win32 Release"
# Name "MyTunetSvc - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=..\des.c
# End Source File
# Begin Source File

SOURCE=..\dot1x.c
# End Source File
# Begin Source File

SOURCE=..\ethcard_bpf.c
# End Source File
# Begin Source File

SOURCE=..\ethcard_eth.c
# End Source File
# Begin Source File

SOURCE=..\ethcard_win.c
# End Source File
# Begin Source File

SOURCE=..\logs.c
# End Source File
# Begin Source File

SOURCE=..\md5.c
# End Source File
# Begin Source File

SOURCE=..\mytunet.c
# End Source File
# Begin Source File

SOURCE=..\mytunetsvc.c
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

SOURCE=..\tunet.c
# End Source File
# Begin Source File

SOURCE=..\userconfig.c
# End Source File
# Begin Source File

SOURCE=..\util.c
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=..\des.h
# End Source File
# Begin Source File

SOURCE=..\dot1x.h
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

SOURCE=..\mytunet.h
# End Source File
# Begin Source File

SOURCE=..\mytunetsvc.h
# End Source File
# Begin Source File

SOURCE=..\os.h
# End Source File
# Begin Source File

SOURCE=..\setting.h
# End Source File
# Begin Source File

SOURCE=.\SVCHelper.h
# End Source File
# Begin Source File

SOURCE=..\tunet.h
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
# Begin Group "Svc"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\MyTunetSvcWin32.c
# End Source File
# Begin Source File

SOURCE=.\SVCHelper.c
# End Source File
# End Group
# End Target
# End Project
