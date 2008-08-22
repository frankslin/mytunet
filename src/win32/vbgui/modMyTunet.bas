Attribute VB_Name = "modMyTunet"
Option Explicit

Public Const LIMITATION_DOMESTIC As Long = &H0
Public Const LIMITATION_CAMPUS As Long = &HFFFFFFFF
Public Const LIMITATION_NONE As Long = &H7FFFFFFF


Public Enum TUNET_STATES
    TUNET_STATE_NONE = 0

    TUNET_STATE_LOGIN
    TUNET_STATE_SEND_LOGON
    TUNET_STATE_RECV_WELCOME
    TUNET_STATE_REPLY_WELCOME
    TUNET_STATE_RECV_REMAINING_DATA

    TUNET_STATE_KEEPALIVE
    TUNET_STATE_FAILURE

    TUNET_STATE_LOGOUT
    TUNET_STATE_LOGOUT_SEND_LOGOUT
    TUNET_STATE_LOGOUT_RECV_LOGOUT
    TUNET_STATE_ERROR
    
    
    
    TUNET_STATE_forvb_KEEPALIVE_CONFIRM = &HFFFFFF + 1
End Enum


Public Enum DOT1X_STATES
    DOT1X_STATE_NONE = 0
    DOT1X_STATE_LOGIN
    DOT1X_STATE_LOGOUT
    DOT1X_STATE_RESPONSE
    DOT1X_STATE_AUTH
    DOT1X_STATE_FAILURE
    DOT1X_STATE_SUCCESS
    DOT1X_STATE_ERROR
End Enum

Public Const SERVICE_STOPPED = &H1
Public Const SERVICE_START_PENDING = &H2
Public Const SERVICE_STOP_PENDING = &H3
Public Const SERVICE_RUNNING = &H4
Public Const SERVICE_CONTINUE_PENDING = &H5
Public Const SERVICE_PAUSE_PENDING = &H6
Public Const SERVICE_PAUSED = &H7


Public Declare Function GetEthcardCount Lib "mytunetdll.dll" () As Long
Public Declare Function GetEthcardInfo Lib "mytunetdll.dll" (ByVal n As Long, e As Any) As Long

Public Declare Function MyTunetCreateMutex Lib "mytunetdll.dll" () As Long
Public Declare Function MyTunetIsWirelessSvcRunning Lib "mytunetdll.dll" () As Long

Public Declare Sub MyTunetSetUserConfig Lib "mytunetdll.dll" (ByVal szUserName As String, ByVal szPassword As String, ByVal isMD5 As Long, ByVal szAdapter As String, ByVal limit As Long, ByVal language As Long)
Public Declare Sub MyTunetSetUserConfigDot1x Lib "mytunetdll.dll" (ByVal bUseDot1x As Long, ByVal bRetryDot1x As Long)
Public Declare Function MyTunetGetUserConfigLimitation Lib "mytunetdll.dll" () As Long

Public Declare Sub Dot1xStart Lib "mytunetdll.dll" ()
Public Declare Sub Dot1xStop Lib "mytunetdll.dll" ()
Public Declare Function Dot1xGetState Lib "mytunetdll.dll" () As Long
Public Declare Function Dot1xIsTimeout Lib "mytunetdll.dll" () As Long
Public Declare Function Dot1xReset Lib "mytunetdll.dll" () As Long

Public Declare Sub TunetStart Lib "mytunetdll.dll" ()
Public Declare Sub TunetReset Lib "mytunetdll.dll" ()
Public Declare Sub TunetStop Lib "mytunetdll.dll" (ByVal timeout As Long, ByVal DoEventProc As Long, ByVal param As Long)
Public Declare Function TunetGetState Lib "mytunetdll.dll" () As Long
Public Declare Function TunetIsKeepaliveTimeout Lib "mytunetdll.dll" () As Long

Public Declare Function MyTunetLogFetch Lib "mytunetdll.dll" () As Long
Public Declare Sub MyTunetLogFree Lib "mytunetdll.dll" (ByVal hLog As Long)

Public Declare Function MyTunetLog_GetStringLen Lib "mytunetdll.dll" (ByVal hLog As Long) As Long
Public Declare Sub MyTunetLog_GetString Lib "mytunetdll.dll" (ByVal hLog As Long, ByVal szStr As String)
Public Declare Function MyTunetLog_GetDataLen Lib "mytunetdll.dll" (ByVal hLog As Long) As Long
Public Declare Sub MyTunetLog_GetData Lib "mytunetdll.dll" (ByVal hLog As Long, b As Any)
Public Declare Sub MyTunetLog_GetTag Lib "mytunetdll.dll" (ByVal hLog As Long, ByVal szTag As String)


Public Declare Function ProtectData Lib "mytunetdll.dll" (b As Any, ByVal Length As Long, optpwd As Any) As Long
Public Declare Function UnprotectData Lib "mytunetdll.dll" (b As Any, ByVal Length As Long, optpwd As Any) As Long
Public Declare Function FreeDataBlob Lib "mytunetdll.dll" (ByVal hData As Long) As Long
Public Declare Function DataBlob_GetLen Lib "mytunetdll.dll" (ByVal hData As Long) As Long
Public Declare Sub DataBlob_GetData Lib "mytunetdll.dll" (ByVal hData As Long, b As Any)



Public Declare Sub MyTunetSvcSetUserConfig Lib "mytunetdll.dll" (ByVal szUserName As String, ByVal szPassword As String, ByVal isMD5 As Long, ByVal szAdapter As String, ByVal limit As Long, ByVal language As Long)
Public Declare Sub MyTunetSvcSetUserConfigDot1x Lib "mytunetdll.dll" (ByVal bUseDot1x As Long, ByVal bRetryDot1x As Long)

Public Declare Function MyTunetSvcGetLogByMailSlot Lib "mytunetdll.dll" (ByVal hSlot As Long) As Long
Public Declare Function MyTunetSvcCreateLogsMailSlot Lib "mytunetdll.dll" () As Long

Public Declare Function MyTunetSvcGetState Lib "mytunetdll.dll" () As Long
Public Declare Function MyTunetSvcInstall Lib "mytunetdll.dll" (ByVal szCmdLine As String) As Long
Public Declare Function MyTunetSvcRemove Lib "mytunetdll.dll" () As Long
Public Declare Function MyTunetSvcStart Lib "mytunetdll.dll" () As Long
Public Declare Function MyTunetSvcStop Lib "mytunetdll.dll" () As Long

Public Declare Function MyTunetSvcLogout Lib "mytunetdll.dll" () As Long
Public Declare Function MyTunetSvcLogin Lib "mytunetdll.dll" () As Long

Public Declare Function MyTunetSvcIsInstalled Lib "mytunetdll.dll" () As Long


Public Type RAW_ETHCARD_INFO
    szName As String * 255
    szDesc As String * 255
    szMac As String * 255
    szIp As String * 255
    live As Long
End Type


Public Type ETHCARD_INFO
    szName As String
    szDesc As String
    szMac As String
    szIp As String
    live As Long
End Type


Public Enum ENUM_LOG_LEVEL
    LOG_LEVEL_0
    LOG_LEVEL_1
    LOG_LEVEL_2
    LOG_LEVEL_3
End Enum
    
Public EthCards() As ETHCARD_INFO
Public EthCardCount As Long

Public MyTunetSvcLogsMailSlotHandle As Long
Public MyTunetSvcLimitation As Long

Public Function EthcardName2Idx(ByVal S As String) As Long
    Dim i As Long
    For i = 0 To UBound(EthCards)
        If EthCards(i).szName = S Then EthcardName2Idx = i: Exit Function
    Next
    EthcardName2Idx = -1
End Function

Sub RefreshEthcards()
    Dim ei As RAW_ETHCARD_INFO
    Dim i As Long
    
    
    EthCardCount = GetEthcardCount
    
    If EthCardCount > 0 Then ReDim EthCards(0 To EthCardCount - 1)
    
    For i = 0 To EthCardCount - 1
        GetEthcardInfo i, ei
        
        EthCards(i).szName = Left(ei.szName, InStr(ei.szName, Chr(0)) - 1)
        EthCards(i).szDesc = Left(ei.szDesc, InStr(ei.szDesc, Chr(0)) - 1)
        EthCards(i).szIp = Left(ei.szIp, InStr(ei.szIp, Chr(0)) - 1)
        EthCards(i).szMac = Left(ei.szMac, InStr(ei.szMac, Chr(0)) - 1)
        EthCards(i).live = ei.live
        
        'Debug.Print EthCards(i).szName
    Next
End Sub



Public Sub MyDoEvents(ByVal param As Long)
    DoEvents
End Sub


Public Sub UpdateTrayIconStatus(Optional ByVal nDot1xStatus As Long = &HFFFFFF, Optional ByVal nTunetStatus As Long = &HFFFFFF)
    Dim LIMITATION As Long
    Static nAniCount As Long
    Dim prefix As String
    Dim szTmp As String
    
    
    Const MISSING_VAR = &HFFFFFF
    
    If nDot1xStatus = MISSING_VAR Or nTunetStatus = MISSING_VAR Then
        
        If MyTunetSvcIsInstalled Then Exit Sub
        
        If nDot1xStatus = MISSING_VAR Then
            nDot1xStatus = Dot1xGetState
        End If
        
        If nTunetStatus = MISSING_VAR Then
            nTunetStatus = TunetGetState
        End If
    End If
    
    LIMITATION = MyTunetGetUserConfigLimitation
    
    If MyTunetSvcIsInstalled Then
        prefix = tr("[MyTunet Service] ")
        LIMITATION = MyTunetSvcLimitation
    End If
    
    
    If CurrentAccountConfig.bUseDot1x <> 0 Then
        If nDot1xStatus = DOT1X_STATE_NONE Then
        
            nAniCount = 0
            SetTrayIconInfo frmBackground.imgStatusNA.Picture.Handle, prefix + tr("MyTunet Ready")
            
            Exit Sub
        End If
        
        If nDot1xStatus <> DOT1X_STATE_SUCCESS And nDot1xStatus <> DOT1X_STATE_NONE Then
            nAniCount = nAniCount + 1
            SetTrayIconInfo frmBackground.imgStatusDot1x(nAniCount Mod 2).Picture.Handle, prefix + tr("802.1x Authenticating ...")
            
            Exit Sub
        End If
    End If
    
    If nTunetStatus <> TUNET_STATE_KEEPALIVE _
        And nTunetStatus <> TUNET_STATE_NONE Then
        
        nAniCount = nAniCount + 1
        
        Select Case LIMITATION
            Case LIMITATION_CAMPUS
                SetTrayIconInfo frmBackground.imgStatusCampus(nAniCount Mod 2).Picture.Handle, prefix + tr("Tunet Authenticating ...")
            Case LIMITATION_DOMESTIC
                SetTrayIconInfo frmBackground.imgStatusDomestic(nAniCount Mod 2).Picture.Handle, prefix + tr("Tunet Authenticating ...")
            Case LIMITATION_NONE
                SetTrayIconInfo frmBackground.imgStatusNoLimitation(nAniCount Mod 2).Picture.Handle, prefix + tr("Tunet Authenticating ...")
        End Select
        
        Exit Sub
    End If
    
    If nTunetStatus = TUNET_STATE_KEEPALIVE Then
    
        nAniCount = 0
        szTmp = prefix + tr("MyTunet Online (Balance: ") + AccountMoney + tr(", used: ") + AccountUsedMoney + ")"
        Select Case LIMITATION
            Case LIMITATION_CAMPUS
                SetTrayIconInfo frmBackground.imgStatusCampus(0).Picture.Handle, szTmp
            Case LIMITATION_DOMESTIC
                SetTrayIconInfo frmBackground.imgStatusDomestic(0).Picture.Handle, szTmp
            Case LIMITATION_NONE
                SetTrayIconInfo frmBackground.imgStatusNoLimitation(0).Picture.Handle, szTmp
        End Select
        
        Exit Sub
    End If
    
    If nTunetStatus = TUNET_STATE_NONE And nDot1xStatus <> DOT1X_STATE_NONE Then
    
        nAniCount = 0
        SetTrayIconInfo frmBackground.imgStatusDot1x(0).Picture.Handle, prefix + tr("802.1x Authenticated")
        
        Exit Sub
    End If
    
    If nTunetStatus = TUNET_STATE_NONE And nDot1xStatus = DOT1X_STATE_NONE Then
        nAniCount = 0
        SetTrayIconInfo frmBackground.imgStatusNA.Picture.Handle, prefix + tr("MyTunet Ready")
        Exit Sub
    End If
    
    Debug.Print "[UpdateTrayIconStatus] Impossible case! "
End Sub
