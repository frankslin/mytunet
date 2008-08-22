Attribute VB_Name = "modMyTunetAccount"
Option Explicit



Public Type LIMITATION
    szName As String
    lngValue As Long
End Type


Public Type GUI_ACCOUNTCONFIG
    szAdapter As String
    
    szUserName As String
    
    szPassword As String
    bUseMD5 As Long
    bIsPasswordMD5 As Long
    
    nLimitation As Long
        
    bRetryDot1x As Long
    bUseDot1x As Long
    bUseReg As Long
    
    fWarnMoney As Double
End Type

Public Limitations(0 To 2) As LIMITATION
Public AccountMoney As String
Public AccountUsedMoney As String
Public CurrentAccountConfig As GUI_ACCOUNTCONFIG

Public Function IsAccountNameValid(ByVal S As String) As Boolean
    Const chkstr = "abcdefghijklmnopqrstuvwxyz0123456789-_+."
    S = LCase(S)
    Dim i As Long
    For i = 1 To Len(S)
        If InStr(chkstr, Mid(S, i, 1)) = 0 And Asc(Mid(S, i, 1)) >= 0 Then
            IsAccountNameValid = False
            Exit Function
        End If
    Next
    IsAccountNameValid = True
End Function




Public Function EncryptBuf(inn() As Byte, Optional ByVal pwd As String = "")
    Dim out() As Byte
    Dim h As Long, l As Long
    
    If SafeUBound(inn) >= 0 Then
        h = ProtectData(inn(0), UBound(inn) + 1, ByVal pwd)
        l = DataBlob_GetLen(h)
        ReDim out(0 To l - 1)
        DataBlob_GetData h, out(0)
        FreeDataBlob h
    End If
    
    EncryptBuf = out
End Function


Public Function DecryptBuf(inn() As Byte, Optional ByVal pwd As String = "")
    Dim out() As Byte
    Dim h As Long, l As Long
    
    If SafeUBound(inn) >= 0 Then
        h = UnprotectData(inn(0), UBound(inn) + 1, ByVal pwd)
        l = DataBlob_GetLen(h)
        
        If l <= 0 Then Exit Function
        
        ReDim out(0 To l - 1)
        DataBlob_GetData h, out(0)
        FreeDataBlob h
    End If
    
    DecryptBuf = out
End Function



Public Sub SetLimitationsList(cmb As ComboBox)
    Dim i As Long
    Dim oldidx As Long
    oldidx = cmb.ListIndex
    cmb.Clear
    On Error Resume Next
    For i = 0 To UBound(Limitations)
        cmb.AddItem tr(Limitations(i).szName)
    Next
    cmb.ListIndex = oldidx
End Sub




Public Property Get GetDefaultConfig(key, def)
    GetDefaultConfig = GetConfig("Default", key, def)
End Property


Public Property Let DefaultConfig(key, value)
    Config("Default", key) = value
End Property


Public Property Let Config(section, key, value)
    SaveSetting "MyTunet", section, key, value
End Property


Public Property Get GetConfig(section, key, def)
    GetConfig = GetSetting("MyTunet", section, key, def)
End Property

Public Property Let AccountConfig(account, key, value)
    SaveSetting "MyTunet", "ACCOUNT-" + account, key, value
End Property

Public Property Get GetAccountConfig(account, key, def)
    GetAccountConfig = GetConfig("ACCOUNT-" + account, key, def)
End Property


Function LoadAccountConfig(Optional ByVal szAccountName As String = "Default") As GUI_ACCOUNTCONFIG
    Dim szSection As String
    Dim uc As GUI_ACCOUNTCONFIG
    
    If szAccountName <> "Default" Then
        szSection = "ACCOUNT-" + szAccountName
    Else
        szSection = "Default"
    End If
    
    With uc
        
        .szUserName = GetConfig(szSection, "Username", "")
    
        .bUseDot1x = Val(GetConfig(szSection, "UseDot1x", "1"))
        .bRetryDot1x = Val(GetConfig(szSection, "RetryDot1x", "0"))
        
        .nLimitation = GetConfig(szSection, "Limitation", Format(Limitation2Idx(1)))
            
        
        .bIsPasswordMD5 = Val(GetConfig(szSection, "IsPasswordMD5", "1"))
        .bUseMD5 = Val(GetConfig(szSection, "UseMD5", "1"))
        
        .bUseReg = Val(GetConfig(szSection, "UseReg", "0"))
        
        .fWarnMoney = Val(GetConfig(szSection, "WarnMoney", "-20"))
        
        
        Dim S As String
        S = GetConfig(szSection, "Password", "")
        If S <> "" Then
            On Error Resume Next
            .szPassword = Buf2Str(DecryptBuf(Hex2Buf(S)))
            On Error GoTo 0
        End If

        .szAdapter = GetConfig("Default", "Adapter", "")
    End With
    LoadAccountConfig = uc
End Function

Sub SaveAccountConfig(uc As GUI_ACCOUNTCONFIG, Optional ByVal szAccount As String = "Default")
    Dim szSection As String
    
    If szAccount <> "Default" Then
        szSection = "ACCOUNT-" + szAccount
    Else
        szSection = "Default"
    End If
    
    With uc
        SaveSetting "MyTunet", szSection, "Adapter", .szAdapter
        
        If szSection = "Default" And Val(GetDefaultConfig("SaveUsernamePassword", "0")) = 0 Then
            SaveSetting "MyTunet", szSection, "Username", ""
            SaveSetting "MyTunet", szSection, "Password", ""
        Else
            SaveSetting "MyTunet", szSection, "Username", .szUserName
            SaveSetting "MyTunet", szSection, "Password", Buf2Hex(EncryptBuf(Str2Buf(.szPassword)))
        End If
        
        SaveSetting "MyTunet", szSection, "UseDot1x", Format(.bUseDot1x)
        SaveSetting "MyTunet", szSection, "RetryDot1x", Format(.bRetryDot1x)
        
        SaveSetting "MyTunet", szSection, "Limitation", Format(.nLimitation)
        
        SaveSetting "MyTunet", szSection, "IsPasswordMD5", Format(.bIsPasswordMD5)
        SaveSetting "MyTunet", szSection, "UseMD5", Format(.bUseMD5)
        
        SaveSetting "MyTunet", szSection, "UseReg", Format(.bUseReg)
        
        SaveSetting "MyTunet", szSection, "WarnMoney", Format(.fWarnMoney)
    End With
End Sub


Sub RefreshLimitations()
    Limitations(0).szName = "Campus"
    Limitations(0).lngValue = LIMITATION_CAMPUS
    
    Limitations(1).szName = "Domestic"
    Limitations(1).lngValue = LIMITATION_DOMESTIC

    Limitations(2).szName = "No Limitation"
    Limitations(2).lngValue = LIMITATION_NONE
End Sub

Function Limitation2Idx(ByVal l As Long) As Long
    Select Case l
        Case LIMITATION_CAMPUS
            Limitation2Idx = 0
        Case LIMITATION_DOMESTIC
            Limitation2Idx = 1
        Case LIMITATION_NONE
            Limitation2Idx = 2
        Case Else
            Limitation2Idx = 1
    End Select
End Function

Function Idx2Limitation(ByVal i As Long) As Long
    Idx2Limitation = Limitations(i).lngValue
End Function

