Attribute VB_Name = "modGlobal"
Option Explicit


Public Const MYTUNET_VERSION = "2005.12.31"


Dim colTexts As New Collection, colTrans  As New Collection
Dim szTransFile As String


Function LoadTranslation(ByVal szLocale As String) As Boolean
    Dim t As String
    Dim S As String
    Dim i As Long
    Dim cc As Collection

    
    If szLocale = "en" Or szLocale = "" Or szLocale = "us" Then
        szTransFile = ""
        Set cc = colTexts
        Set colTexts = colTrans
        Set colTrans = cc
        Exit Function
    End If
    
    While colTexts.Count
        colTexts.Remove colTexts.Count
    Wend
    
    While colTrans.Count
        colTrans.Remove colTrans.Count
    Wend
    
    szTransFile = AppPath + "trans_" + szLocale + ".data"
    On Error GoTo SkipErr
    Open szTransFile For Input As #1

    While Not EOF(1)
        Line Input #1, t
        If Trim(t) <> "" Then
            t = Mid(t, 2)
            t = Left(t, Len(t) - 1)
            t = Replace(t, """" + """", """")
            colTexts.Add t
                    
            
            Line Input #1, t
            t = Mid(t, 2)
            t = Left(t, Len(t) - 1)
            t = Replace(t, """" + """", """")
            colTrans.Add t
        
        End If
    Wend
    Close #1
    Exit Function
SkipErr:
    MessageBox 0, tr("Error while loading translation data."), "MyTunet", vbCritical
End Function

'Translation function
Function tr(ByVal S As String) As String
    On Error Resume Next
    Dim i As Long
    For i = 1 To colTexts.Count
        If colTexts(i) = S Then
            tr = colTrans(i)
            Exit For
        End If
    Next
    
    If tr = "" Then
        If szTransFile <> "" Then Debug.Print "Untranslated:", S
        tr = S
    End If
End Function

Function trForm(f As Form)
    Dim o, i As Long
    For Each o In f

        f.Caption = tr(f.Caption)
        
        Select Case TypeName(o)
            Case "CheckBox", "Form", "OptionButton", "Label", "CommandButton", "Frame", "Menu"
                If o.Name <> "mnuAccount" Then
                    o.Caption = tr(o.Caption)
                Else
                    If o.Index = 0 Then o.Caption = tr(o.Caption)
                End If
            Case "ComboBox"
                If o.Style <> 0 Then
                    For i = 0 To o.ListCount - 1
                        o.List(i) = tr(o.List(i))
                    Next
                End If
        End Select
    Next
End Function
Function Hex2Buf(ByVal szHex As String)
    Dim b() As Byte
    Dim t As String, i As Integer
    t = szHex
    t = Replace(t, "\x", "")
    t = Replace(t, "&h", "")
    t = Replace(t, "0x", "")
    t = Replace(t, " ", "")
    t = Replace(t, Chr(10), "")
    t = Replace(t, Chr(13), "")
    t = Replace(t, Chr(9), "")
    
    If Len(t) Mod 2 <> 0 Then Exit Function
    
    If Len(t) > 0 Then
        ReDim b(Len(t) / 2 - 1)
        
        For i = 0 To Len(t) / 2 - 1
            b(i) = CInt("&H" & Mid(t, i * 2 + 1, 2))
        Next
    End If
    Hex2Buf = b
End Function



Function Buf2Hex(b() As Byte, Optional bLower As Boolean = True, Optional bNoBlank As Boolean = True) As String
    Dim i As Long
    Dim r As String
    On Error Resume Next
    For i = 0 To SafeUBound(b)
        r = r + " " + Right("00" + Hex(b(i)), 2)
    Next
    Buf2Hex = r
    If bLower Then Buf2Hex = LCase(Buf2Hex)
    If bNoBlank Then Buf2Hex = Replace(Buf2Hex, " ", "")
End Function


Function Str2Hex(ByVal szStr As String, Optional bLower As Boolean = True, Optional bNoBlank As Boolean = True) As String
    Dim i As Long
    
    For i = 1 To Len(szStr)
        Str2Hex = Str2Hex + Right("00" + Hex(Asc(Mid(szStr, i, 1))), 2) + " "
    Next
    If bLower Then Str2Hex = LCase(Str2Hex)
    If bNoBlank Then Str2Hex = Replace(Str2Hex, " ", "")
End Function

Function Hex2Str(ByVal szHex As String) As String
    Dim b() As Byte
    b = Hex2Buf(szHex)
    Hex2Str = StrConv(b, vbUnicode)
End Function

Function Buf2Str(b() As Byte) As String
    Buf2Str = StrConv(b, vbUnicode)
End Function

Function Str2Buf(ByVal szStr As String)
    Dim b() As Byte
    b = StrConv(szStr, vbFromUnicode)
    Str2Buf = b
End Function

Public Function AppPath() As String
    AppPath = IIf(Right(App.Path, 1) = "\", App.Path, App.Path + "\")
End Function

Public Function SystemPath() As String
    Dim S As String
    S = Space(255)
    GetSystemDirectory S, Len(S)
    S = Left(S, InStr(S, Chr(0)) - 1)
    SystemPath = S + "\"
End Function

Public Function CurrentWindowsUser() As String
    Dim S As String
    S = Space(1024)
    GetUserName S, Len(S)
    S = Left(S, InStr(S, Chr(0)) - 1)
    CurrentWindowsUser = S
End Function


Sub InstallPCap()

    On Error Resume Next
    'Clean the old files
    Kill AppPath + "wpcap.dll"
    Kill AppPath + "pthreadVC.dll"
    Kill AppPath + "packet.dll"
    Kill AppPath + "wanpacket.dll"
    On Error GoTo 0
    
    If Dir(SystemPath + "drivers\npf.sys", vbHidden + vbNormal + vbReadOnly + vbSystem) = "" Or _
        Dir(SystemPath + "packet.dll", vbHidden + vbNormal + vbReadOnly + vbSystem) = "" Or _
        Dir(SystemPath + "pthreadVC.dll", vbHidden + vbNormal + vbReadOnly + vbSystem) = "" Or _
        Dir(SystemPath + "wanpacket.dll", vbHidden + vbNormal + vbReadOnly + vbSystem) = "" Or _
        Dir(SystemPath + "wpcap.dll", vbHidden + vbNormal + vbReadOnly + vbSystem) = "" Then
        
        Dim bIsWOW64 As Long
        On Error Resume Next
        IsWow64Process GetCurrentProcess(), bIsWOW64
        If bIsWOW64 Then
            FileCopy AppPath + "driver\npf_amd64.sys", SystemPath + "drivers\npf.sys"
        Else
            FileCopy AppPath + "driver\npf.sys", SystemPath + "drivers\npf.sys"
        End If
        FileCopy AppPath + "driver\packet.dll", SystemPath + "packet.dll"
        FileCopy AppPath + "driver\pthreadVC.dll", SystemPath + "pthreadVC.dll"
        FileCopy AppPath + "driver\wanpacket.dll", SystemPath + "wanpacket.dll"
        FileCopy AppPath + "driver\wpcap.dll", SystemPath + "wpcap.dll"
        
        On Error GoTo 0
        
    End If
    
    If Dir(SystemPath + "drivers\npf.sys", vbHidden + vbNormal + vbReadOnly + vbSystem) = "" Or _
        Dir(SystemPath + "packet.dll", vbHidden + vbNormal + vbReadOnly + vbSystem) = "" Or _
        Dir(SystemPath + "pthreadVC.dll", vbHidden + vbNormal + vbReadOnly + vbSystem) = "" Or _
        Dir(SystemPath + "wanpacket.dll", vbHidden + vbNormal + vbReadOnly + vbSystem) = "" Or _
        Dir(SystemPath + "wpcap.dll", vbHidden + vbNormal + vbReadOnly + vbSystem) = "" Then
        
        MsgBox tr("Unable to install WinPCap. Please install it manually."), vbCritical
        End
    End If
End Sub

Sub Main()
    App.TaskVisible = False
    LoadTranslation "zh_CN"
    
    If LCase$(Trim$(Command)) = "-checkupdate" Then
        CheckUpdate
    Else
        InstallPCap
        Load frmMain
    End If
End Sub


