Attribute VB_Name = "modMyTunetUpdate"
Option Explicit

Private Declare Function InternetOpen Lib "wininet.dll" Alias "InternetOpenA" (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, ByVal sProxyBypass As String, ByVal lFlags As Long) As Long
Private Declare Function InternetOpenUrl Lib "wininet.dll" Alias "InternetOpenUrlA" (ByVal hOpen As Long, ByVal surl As String, ByVal sHeaders As String, ByVal lLength As Long, ByVal lFlags As Long, ByVal lContext As Long) As Long
Private Declare Function InternetReadFile Lib "wininet.dll" (ByVal hFile As Long, ByRef sBuffer As Byte, ByVal lNumBytesToRead As Long, lNumberOfBytesRead As Long) As Integer
Private Declare Function InternetCloseHandle Lib "wininet.dll" (ByVal hInet As Long) As Integer
Const INTERNET_OPEN_TYPE_PRECONFIG = 0
Const INTERNET_OPEN_TYPE_DIRECT = 1
Const INTERNET_OPEN_TYPE_PROXY = 3
Const INTERNET_FLAG_RELOAD = &H80000000

Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long

Type TUpdateInfo
    FileName As String
    Major As String
    Minor As String
    Revision As String
    Detail As String
    URLName As String
    URL As String
    OfficalURL As String
End Type

Const OFFICAL_SERVER_ADDRESS = "http://www.mytunet.com/UpdateInfo.ini"

Public gCheckUpdate As Boolean


Public Sub AnalyzeFile(FilePath As String)
    Dim Info As TUpdateInfo
    Dim ReadResult As Long
    Dim ReadInfo As String
    
    ReadInfo = String(1000, Chr$(0))
    
    ReadResult = GetPrivateProfileString("Program", "Name", "", ReadInfo, 1000, FilePath)
    
    '确认文件正确
    If Replace(ReadInfo, Chr$(0), "") <> "MyTunet" Then
      Exit Sub
    End If
    
    '更新文件名 未启用
    ReadInfo = String(1000, Chr$(0))
    ReadResult = GetPrivateProfileString("File Name", "File1", "", ReadInfo, 1000, FilePath)
    Info.FileName = Replace(ReadInfo, Chr$(0), "")
    
    '主版本号
    ReadInfo = String(1000, Chr$(0))
    ReadResult = GetPrivateProfileString("Version", "Major1", "", ReadInfo, 1000, FilePath)
    Info.Major = Replace(ReadInfo, Chr$(0), "")
    
    '副版本号
    ReadInfo = String(1000, Chr$(0))
    ReadResult = GetPrivateProfileString("Version", "Minor1", "", ReadInfo, 1000, FilePath)
    Info.Minor = Replace(ReadInfo, Chr$(0), "")
    
    '修正号
    ReadInfo = String(1000, Chr$(0))
    ReadResult = GetPrivateProfileString("Version", "Revision1", "", ReadInfo, 1000, FilePath)
    Info.Revision = Replace(ReadInfo, Chr$(0), "")
    
    '更新描述
    ReadInfo = String(1000, Chr$(0))
    ReadResult = GetPrivateProfileString("Description", "Detail1", "", ReadInfo, 1000, FilePath)
    Info.Detail = Replace(ReadInfo, Chr$(0), "")
    
    '更新文件下载链接名称
    ReadInfo = String(1000, Chr$(0))
    ReadResult = GetPrivateProfileString("Download URL", "URLName1", "", ReadInfo, 1000, FilePath)
    Info.URLName = Replace(ReadInfo, Chr$(0), "")
    
    '更新文件下载链接
    ReadInfo = String(1000, Chr$(0))
    ReadResult = GetPrivateProfileString("Download URL", "URL1", "", ReadInfo, 1000, FilePath)
    Info.URL = Replace(ReadInfo, Chr$(0), "")
    
    '官方主页链接
    ReadInfo = String(1000, Chr$(0))
    ReadResult = GetPrivateProfileString("Official URL", "URL", "", ReadInfo, 1000, FilePath)
    Info.OfficalURL = Replace(ReadInfo, Chr$(0), "")
    
    
    Dim CurMajor As Long, CurMinor As Long, CurRevision As Long
    Dim v
    
    v = Split(MYTUNET_VERSION, ".")
    CurMajor = Val(v(0))
    CurMinor = Val(v(1))
    CurRevision = Val(v(2))
    
    Dim bNeedUpdate As Boolean
    bNeedUpdate = False
    If Val(Info.Major) > CurMajor Then
        bNeedUpdate = True
    Else
        If Val(Info.Major) = CurMajor And Val(Info.Minor) > CurMinor Then
            bNeedUpdate = True
        Else
            If Val(Info.Minor) = CurMinor And Val(Info.Revision) > CurRevision Then
                bNeedUpdate = True
            End If
        End If
    End If

    If bNeedUpdate Then
        SetUpdateInfo Info
    Else
        End
    End If
End Sub

Public Sub CheckUpdate()
    
    Dim hOpen As Long
    Dim hOpenUrl As Long
    Dim bRead As Long
    
    Dim bReadBuffer() As Byte
    Dim lNumberOfBytesRead As Long
    Dim lBytesCount As Long
    
    lNumberOfBytesRead = 0
    lBytesCount = 0
    bRead = True
    
    hOpen = InternetOpen("MyTunet", INTERNET_OPEN_TYPE_PRECONFIG, vbNullString, vbNullString, 0)
    hOpenUrl = InternetOpenUrl(hOpen, OFFICAL_SERVER_ADDRESS, vbNullString, 0, INTERNET_FLAG_RELOAD, 0)
    
    'MsgBox "CheckUpdate"
    
    If hOpen <> 0 And hOpenUrl <> 0 Then
        ReDim bReadBuffer(1024 - 1)
                
        Do
            bRead = InternetReadFile(hOpenUrl, bReadBuffer(lBytesCount), 1024, lNumberOfBytesRead)
            lBytesCount = lBytesCount + lNumberOfBytesRead
            
            If (bRead <> 0) And (lNumberOfBytesRead > 0) Then
                ReDim Preserve bReadBuffer(lBytesCount - 1 + 1024)
            End If
            
        Loop Until bRead = 0 Or lNumberOfBytesRead <= 0
        
        ReDim Preserve bReadBuffer(lBytesCount - 1)
        
        
        On Error Resume Next
        Kill AppPath + "UpdateInfo.ini"
        Open AppPath + "UpdateInfo.ini" For Binary As #1
        Put #1, 1, bReadBuffer
        Close #1
        On Error GoTo 0
    End If
        
    If hOpen <> 0 Then InternetCloseHandle hOpen
    If hOpenUrl <> 0 Then InternetCloseHandle hOpenUrl
        
    AnalyzeFile AppPath + "UpdateInfo.ini"
End Sub


Public Sub SetUpdateInfo(Info As TUpdateInfo)
    frmUpdate.lblVersion.Caption = Info.Major + "." + Info.Minor + "." + Info.Revision
    frmUpdate.txtDescription.Text = Info.Detail
    frmUpdate.lblOfficalClick.Caption = Info.OfficalURL
    frmUpdate.lblDownloadClick.Caption = Info.URLName
    frmUpdate.lblOfficalClick.ToolTipText = Info.OfficalURL
    frmUpdate.lblDownloadClick.ToolTipText = Info.URL
    
    frmUpdate.Show
    'frmUpdate.ShowInTaskbar = True
End Sub
