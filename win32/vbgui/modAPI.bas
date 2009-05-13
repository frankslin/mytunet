Attribute VB_Name = "modAPI"
Option Explicit
Public Declare Function GetCurrentProcess Lib "kernel32" () As Long

Public Declare Function IsWow64Process Lib "kernel32" (ByVal hProcess As Long, bResult As Long) As Long

Public Declare Function HtmlHelp Lib "hhctrl.ocx" Alias "HtmlHelpA" (ByVal hwnd As Long, ByVal szFile As String, ByVal uCmd As Long, ByVal wData As Long) As Long

Public Declare Function DrawIcon Lib "user32" (ByVal hdc As Long, ByVal X As Long, ByVal y As Long, ByVal hIcon As Long) As Long
Public Declare Function DrawIconEx Lib "user32" (ByVal hdc As Long, ByVal xLeft As Long, ByVal yTop As Long, ByVal hIcon As Long, ByVal cxWidth As Long, ByVal cyWidth As Long, ByVal istepIfAniCur As Long, ByVal hbrFlickerFreeDraw As Long, ByVal diFlags As Long) As Long
Public Declare Function GetSystemDirectory Lib "kernel32" Alias "GetSystemDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Public Declare Function IsWindow Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long

Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Public Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Public Declare Function lstrlen Lib "kernel32" Alias "lstrlenA" (ByVal lpString As String) As Long
Public Declare Function RegDeleteValue Lib "advapi32.dll" Alias "RegDeleteValueA" (ByVal hKey As Long, ByVal lpValueName As String) As Long
Public Declare Function RegSetValueEx Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpData As Any, ByVal cbData As Long) As Long
Public Declare Function RegCreateKey Lib "advapi32.dll" Alias "RegCreateKeyA" (ByVal hKey As Long, ByVal lpSubKey As String, phkResult As Long) As Long
Public Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Public Declare Function GetUserName Lib "advapi32.dll" Alias "GetUserNameA" (ByVal lpBuffer As String, nSize As Long) As Long

Public Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Public Declare Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function Shell_NotifyIcon Lib "shell32.dll" Alias "Shell_NotifyIconA" (ByVal dwMessage As Long, lpData As NOTIFYICONDATA) As Long
Public Declare Function RegisterWindowMessage Lib "user32" Alias "RegisterWindowMessageA" (ByVal lpString As String) As Long
Public Declare Function MessageBox Lib "user32" Alias "MessageBoxA" (ByVal hwnd As Long, ByVal lpText As String, ByVal lpCaption As String, ByVal wType As Long) As Long

Public Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
End Type
Public Type POINTAPI
        X As Long
        y As Long
End Type
Public Declare Function CreateMutex Lib "kernel32" Alias "CreateMutexA" (lpMutexAttributes As Any, ByVal bInitialOwner As Long, ByVal lpName As String) As Long
Public Const ERROR_ALREADY_EXISTS = 183&
Public Declare Function GetLastError Lib "kernel32" () As Long

Public Declare Function TrackPopupMenu Lib "user32" (ByVal hMenu As Long, ByVal wFlags As Long, ByVal X As Long, ByVal y As Long, ByVal nReserved As Long, ByVal hwnd As Long, lprc As RECT) As Long
Public Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Public Declare Function GetMenu Lib "user32" (ByVal hwnd As Long) As Long
Public Const TPM_RIGHTBUTTON = &H2&

Public Const WM_COPYDATA = &H4A
Public Type COPYDATASTRUCT
        dwData As Long
        cbData As Long
        lpData As Long
End Type

Public Const WM_MOUSEMOVE = &H200
Public Const WM_LBUTTONDBLCLK = &H203
Public Const WM_LBUTTONDOWN = &H201
Public Const WM_LBUTTONUP = &H202
Public Const WM_MBUTTONDBLCLK = &H209
Public Const WM_MBUTTONDOWN = &H207
Public Const WM_MBUTTONUP = &H208
Public Const WM_RBUTTONDBLCLK = &H206
Public Const WM_RBUTTONDOWN = &H204
Public Const WM_RBUTTONUP = &H205


Public Type NOTIFYICONDATA
        cbSize As Long
        hwnd As Long
        uID As Long
        uFlags As Long
        uCallbackMessage As Long
        hIcon As Long
        szTip As String * 64
End Type

Public Const NIM_ADD = &H0
Public Const NIM_DELETE = &H2
Public Const NIF_ICON = &H2
Public Const NIF_TIP = &H4
Public Const NIF_MESSAGE = &H1
Public Const NIM_MODIFY = &H1
Public Declare Function EnumWindows Lib "user32" (ByVal lpEnumFunc As Long, ByVal lParam As Long) As Long


Public Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long

Public Const GWL_WNDPROC = (-4)


Public Const HKEY_LOCAL_MACHINE = &H80000002
Public Const HKEY_CURRENT_USER = &H80000001
Public Const RegKey = "Software\Microsoft\Windows\CurrentVersion\Run"


Public Const WM_USER = &H400
Public Const WM_TRAYICON = WM_USER + 1452
Public Const ID_TRAYICON = 0
Public WM_TASKBAR_CREATED As Long




' Reg Key Security Options...
Public Const READ_CONTROL = &H20000
Public Const KEY_QUERY_VALUE = &H1
Public Const KEY_SET_VALUE = &H2
Public Const KEY_CREATE_SUB_KEY = &H4
Public Const KEY_ENUMERATE_SUB_KEYS = &H8
Public Const KEY_NOTIFY = &H10
Public Const KEY_CREATE_LINK = &H20
Public Const KEY_ALL_ACCESS = KEY_QUERY_VALUE + KEY_SET_VALUE + _
                       KEY_CREATE_SUB_KEY + KEY_ENUMERATE_SUB_KEYS + _
                       KEY_NOTIFY + KEY_CREATE_LINK + READ_CONTROL
                     
' Reg Key ROOT Types...
'Const HKEY_LOCAL_MACHINE = &H80000002
Public Const ERROR_SUCCESS = 0
Public Const REG_SZ = 1                          ' Unicode nul terminated string
Public Const REG_DWORD = 4                      ' 32-bit number
Public Const REG_BINARY = 3                     ' Free form binary

Public Const gREGKEYSYSINFOLOC = "SOFTWARE\Microsoft\Shared Tools Location"
Public Const gREGVALSYSINFOLOC = "MSINFO"
Public Const gREGKEYSYSINFO = "SOFTWARE\Microsoft\Shared Tools\MSINFO"
Public Const gREGVALSYSINFO = "PATH"

Public Declare Function RegOpenKeyEx Lib "advapi32" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, ByRef phkResult As Long) As Long
Public Declare Function RegQueryValueEx Lib "advapi32" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, ByRef lpType As Long, lpData As Any, ByRef lpcbData As Long) As Long


Dim OldWindowProc As Long
Public MyTray As NOTIFYICONDATA
Public TunetMutex As Long
Public TunetWindowExists As Boolean



Public Function IsWindowsDot1xOpen(ByVal szAdaptorName As String) As Boolean
    Dim rc As Long
    Dim hKey As Long
    Dim nKeyValType As Long
    Dim tmpVal() As Byte
    Dim nKeyValSize As Long
    
    Dim szRegKeyName As String
    
    If szAdaptorName = "" Then
        IsWindowsDot1xOpen = False
        Exit Function
    End If
    
    If Left(szAdaptorName, 1) <> "{" Then
        If InStr(szAdaptorName, "{") = 0 Then
            IsWindowsDot1xOpen = False
            Exit Function
        End If
        
        szAdaptorName = Mid(szAdaptorName, InStr(szAdaptorName, "{"))
    End If
    
    Debug.Print szAdaptorName
    
    szRegKeyName = "SOFTWARE\Microsoft\EAPOL\Parameters\Interfaces\" + szAdaptorName
    rc = RegOpenKeyEx(HKEY_LOCAL_MACHINE, szRegKeyName, 0, KEY_QUERY_VALUE, hKey)
    
    If (rc <> ERROR_SUCCESS) Then GoTo GetKeyError
    
    nKeyValSize = 1024
    ReDim tmpVal(0 To nKeyValSize - 1)
    
    nKeyValType = REG_BINARY
    rc = RegQueryValueEx(hKey, "1", 0, nKeyValType, tmpVal(0), nKeyValSize)
    
    If (rc <> ERROR_SUCCESS) Then GoTo GetKeyError
    
    IsWindowsDot1xOpen = ((tmpVal(11) And &H80) = &H80) And (MyTunetIsWirelessSvcRunning <> 0)
    
    rc = RegCloseKey(hKey)
    Exit Function
    
GetKeyError:
    rc = RegCloseKey(hKey)
End Function




Public Function CheckTUNetWindowsProc(ByVal hwnd As Long, ByVal p As Long) As Long
    Dim S As String
    S = Space(1024)
    GetWindowText hwnd, S, 1023
    S = Left(S, InStr(S, Chr(0)) - 1)

    If InStr(S, "清华大学校园网用户登录系统") <> 0 Or InStr(S, "TUNet for Win") <> 0 Then
        TunetWindowExists = True
        CheckTUNetWindowsProc = 0
    End If
    CheckTUNetWindowsProc = 1
End Function

Public Sub SetAutorun(ByVal Autorun As Boolean)
    Dim KeyId As Long, t As String
    RegCreateKey HKEY_CURRENT_USER, RegKey, KeyId
    If Autorun Then
        t = """" + AppPath + App.EXEName + ".exe" + """" + " autorun"
        RegSetValueEx KeyId, "MyTunet", 0&, REG_SZ, ByVal t, lstrlen(t)
    Else
        RegDeleteValue KeyId, "MyTunet"
    End If
    RegCloseKey KeyId
End Sub


Public Function ReadIni(ByVal szFileName As String, ByVal szSection As String, ByVal szKey As String, ByVal szDefault As String) As String
    Dim szStr As String
    szStr = szDefault + Chr(0) + Space(1000)
    GetPrivateProfileString szSection, szKey, szDefault, szStr, Len(szStr), szFileName
    ReadIni = Left$(szStr, InStr(szStr, Chr(0)) - 1)
End Function

Public Function ReadIniVal(ByVal szFileName As String, ByVal szSection As String, ByVal szKey As String, ByVal szDefault As String) As Double
    Dim szStr As String
    szStr = szDefault + Chr(0) + Space(1000)
    GetPrivateProfileString szSection, szKey, szDefault, szStr, Len(szStr), szFileName
    ReadIniVal = Val(Left$(szStr, InStr(szStr, Chr(0)) - 1))
End Function

Public Sub WriteIni(ByVal szFileName As String, ByVal szSection As String, ByVal szKey As String, ByVal szValue As String)
    WritePrivateProfileString szSection, szKey, szValue, szFileName
End Sub

Public Function ComboItem2Index(cmb As ComboBox, S As String, Optional ByVal def As Long = 0) As Long
    Dim i As Long
    For i = 0 To cmb.ListCount - 1
        If cmb.List(i) = S Then
            ComboItem2Index = i
            Exit Function
        End If
    Next
    ComboItem2Index = def
End Function




Public Function SafeUBound(b) As Long
    On Error GoTo NoElem
    SafeUBound = UBound(b)
    Exit Function
NoElem:
    SafeUBound = -1
End Function




Public Sub SetNewWndProc(ByVal hwnd As Long)
    OldWindowProc = SetWindowLong(hwnd, GWL_WNDPROC, AddressOf WindowProc)
End Sub

Public Sub UnsetNewWndProc(ByVal hwnd As Long)
    SetWindowLong hwnd, GWL_WNDPROC, OldWindowProc
End Sub


Public Sub SetTrayIcon()
    '初始化Tray
    WM_TASKBAR_CREATED = RegisterWindowMessage("TaskbarCreated")
    
    MyTray.hIcon = frmBackground.Icon
    MyTray.cbSize = Len(MyTray)
    MyTray.hwnd = frmBackground.hwnd
    MyTray.uID = ID_TRAYICON
    MyTray.uFlags = NIF_ICON Or NIF_MESSAGE Or NIF_TIP
    MyTray.uCallbackMessage = WM_TRAYICON
    MyTray.szTip = tr("MyTunet Ready") & Chr(0)
    
    If MyTunetSvcIsInstalled Then
        MyTray.szTip = tr("[MyTunet Service] ") + MyTray.szTip
    End If
    
    Shell_NotifyIcon NIM_ADD, MyTray
End Sub

Public Sub UnsetTrayIcon()
    Shell_NotifyIcon NIM_DELETE, MyTray
End Sub

Public Sub SetTrayIconInfo(Optional ByVal hIcon As Long = 0, Optional ByVal szTip As String = "")
    Dim bNeedModify As Boolean
    
    If hIcon <> 0 Then
        If MyTray.hIcon <> hIcon Then
            MyTray.hIcon = hIcon
            bNeedModify = True
            
        End If
    End If
    
    If szTip <> "" Then
        If szTip + Chr(0) <> MyTray.szTip Then
            MyTray.szTip = szTip + Chr(0)
            bNeedModify = True
        End If
    End If
    
    If bNeedModify Then Shell_NotifyIcon NIM_MODIFY, MyTray
End Sub

Public Function WindowProc(ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    Dim hLog As Long
    Dim tag As String, str As String, data() As Byte
    
    Select Case Msg
        Case WM_TRAYICON
            
            If wParam = ID_TRAYICON Then
                Select Case lParam
                    Case WM_LBUTTONUP
                        frmMain.WindowState = vbNormal
                        
                        frmMain.Show
                    Case WM_RBUTTONUP
                        frmMain.mnuCancelShut.Visible = (GetDefaultConfig("AutoShut", 0) <> 0)
                        
                        frmMain.mnuWindowsDot1x.Visible = (Dir(AppPath + "tools\win802.1x.exe", vbHidden + vbNormal + vbReadOnly + vbSystem) <> "")
                        frmMain.mnuIPSwitcher.Visible = (Dir(AppPath + "tools\ipswitcher.exe", vbHidden + vbNormal + vbReadOnly + vbSystem) <> "")
                        
                        frmMain.mnuBar_Tools.Visible = frmMain.mnuWindowsDot1x.Visible Or frmMain.mnuIPSwitcher.Visible
                        frmMain.mnuBar_CancelShut.Visible = frmMain.mnuCancelShut.Visible
                        
                        frmMain.PopupMenu frmMain.mnuPopup, vbPopupMenuRightButton
                End Select
            End If
        Case WM_TASKBAR_CREATED
            SetTrayIcon
    
    
    End Select
    WindowProc = CallWindowProc(OldWindowProc, hwnd, Msg, wParam, lParam)
End Function


Public Function MD5String(ByVal S As String) As String
    Dim md5 As New CMD5
    S = md5.Md5_String_Calc(S)
    S = Replace(S, " ", "")
    S = LCase(S)
    MD5String = S
End Function
