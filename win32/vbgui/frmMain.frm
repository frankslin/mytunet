VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "MyTunet"
   ClientHeight    =   7620
   ClientLeft      =   150
   ClientTop       =   435
   ClientWidth     =   5145
   Icon            =   "frmMain.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   508
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   343
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer tmrUpdateTimer 
      Enabled         =   0   'False
      Interval        =   5000
      Left            =   3510
      Top             =   75
   End
   Begin VB.Timer tmrAutoShutReminder 
      Enabled         =   0   'False
      Interval        =   10000
      Left            =   4065
      Top             =   705
   End
   Begin VB.Frame Frame1 
      Caption         =   "Language"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   570
      Left            =   945
      TabIndex        =   20
      Top             =   3165
      Width           =   2850
      Begin VB.OptionButton optLanguage 
         Caption         =   "English"
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   210
         Index           =   0
         Left            =   1680
         TabIndex        =   22
         Top             =   255
         Width           =   1020
      End
      Begin VB.OptionButton optLanguage 
         Caption         =   "简体中文"
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   210
         Index           =   1
         Left            =   285
         TabIndex        =   21
         Top             =   270
         Width           =   1140
      End
   End
   Begin VB.CommandButton cmdShowHideMessages 
      Caption         =   "<&Messages>"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   3975
      TabIndex        =   19
      Top             =   3840
      Width           =   1095
   End
   Begin VB.Timer tmrServiceTimer 
      Interval        =   1000
      Left            =   4650
      Top             =   75
   End
   Begin VB.CheckBox chkSaveUsernamePassword 
      Caption         =   "Save Last Logon Info"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   945
      TabIndex        =   17
      Top             =   2880
      Width           =   2145
   End
   Begin VB.Timer tmrDelayToRetry 
      Enabled         =   0   'False
      Interval        =   4000
      Left            =   4635
      Top             =   720
   End
   Begin VB.PictureBox picStatus 
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'None
      Height          =   240
      Left            =   300
      Picture         =   "frmMain.frx":1CFA
      ScaleHeight     =   16
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   16
      TabIndex        =   16
      Top             =   2715
      Width           =   240
   End
   Begin VB.CheckBox chkUseDot1x 
      Caption         =   "802.1x Authentication"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   210
      Left            =   945
      TabIndex        =   4
      Top             =   2595
      Width           =   2715
   End
   Begin VB.Timer tmrRealTimer 
      Interval        =   10
      Left            =   4080
      Top             =   75
   End
   Begin VB.ComboBox cmbUsername 
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   960
      TabIndex        =   1
      Top             =   1425
      Width           =   2160
   End
   Begin VB.CommandButton cmdExit 
      Caption         =   "E&xit"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   3975
      TabIndex        =   10
      Top             =   3420
      Width           =   1095
   End
   Begin VB.CommandButton cmdAbout 
      Caption         =   "&About"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   2805
      TabIndex        =   9
      Top             =   3840
      Width           =   1095
   End
   Begin VB.CommandButton cmdHelp 
      BackColor       =   &H00FFC0FF&
      Caption         =   "&Help"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   1635
      Style           =   1  'Graphical
      TabIndex        =   8
      Top             =   3840
      Width           =   1095
   End
   Begin VB.CommandButton cmdConfig 
      Caption         =   "&Configuration"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   90
      TabIndex        =   7
      Top             =   3840
      Width           =   1470
   End
   Begin VB.CommandButton cmdLogout 
      Caption         =   "Logou&t"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   3975
      TabIndex        =   6
      Top             =   3000
      Width           =   1095
   End
   Begin VB.CommandButton cmdLogin 
      Caption         =   "&Login"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   3975
      TabIndex        =   5
      Top             =   2580
      Width           =   1095
   End
   Begin VB.TextBox txtLogs 
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2835
      Left            =   45
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   11
      Top             =   4710
      Width           =   5085
   End
   Begin VB.ComboBox cmbLimitation 
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      ItemData        =   "frmMain.frx":1E44
      Left            =   3300
      List            =   "frmMain.frx":1E51
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   1425
      Width           =   1785
   End
   Begin VB.TextBox txtPassword 
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   960
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   1800
      Width           =   4110
   End
   Begin VB.ComboBox cmbAdapter 
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   960
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   2190
      Width           =   4110
   End
   Begin VB.Line Line2 
      BorderColor     =   &H00FFFFFF&
      X1              =   6
      X2              =   338
      Y1              =   286
      Y2              =   286
   End
   Begin VB.Line lnBottom 
      Visible         =   0   'False
      X1              =   -1
      X2              =   339
      Y1              =   308
      Y2              =   308
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00808080&
      X1              =   6
      X2              =   338
      Y1              =   285
      Y2              =   285
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      Caption         =   "@"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   180
      Left            =   3165
      TabIndex        =   18
      Top             =   1485
      Width           =   90
   End
   Begin VB.Label lblStatus 
      Alignment       =   2  'Center
      Caption         =   "MyTunet"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   45
      TabIndex        =   15
      Top             =   4350
      Width           =   5025
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "Password:"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   180
      Left            =   105
      TabIndex        =   14
      Top             =   1860
      Width           =   810
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Adapter:"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   180
      Left            =   105
      TabIndex        =   13
      Top             =   2235
      Width           =   720
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Username:"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   180
      Left            =   105
      TabIndex        =   12
      Top             =   1470
      Width           =   810
   End
   Begin VB.Image imgMyTunet 
      Height          =   1290
      Left            =   0
      Picture         =   "frmMain.frx":1E76
      Top             =   0
      Width           =   5160
   End
   Begin VB.Menu mnuPopup 
      Caption         =   "Popup"
      Visible         =   0   'False
      Begin VB.Menu mnuShowHide 
         Caption         =   "Show/Hide"
      End
      Begin VB.Menu mnuBar002 
         Caption         =   "-"
      End
      Begin VB.Menu mnuIPSwitcher 
         Caption         =   "IP Switcher"
      End
      Begin VB.Menu mnuWindowsDot1x 
         Caption         =   "Windows 802.1x Logon"
      End
      Begin VB.Menu mnuBar_Tools 
         Caption         =   "-"
      End
      Begin VB.Menu mnuCancelShut 
         Caption         =   "Cancel Shutting-down"
      End
      Begin VB.Menu mnuBar_CancelShut 
         Caption         =   "-"
      End
      Begin VB.Menu mnuAccountList 
         Caption         =   "Account List"
         Begin VB.Menu mnuAccount 
            Caption         =   "--Account List--"
            Enabled         =   0   'False
            Index           =   0
         End
      End
      Begin VB.Menu mnuBar004 
         Caption         =   "-"
      End
      Begin VB.Menu mnuCancel 
         Caption         =   "Cancel this menu"
      End
      Begin VB.Menu mnuBar001 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Enum ENUM_GOAL
    GOAL_NONE
    GOAL_LOGIN
    GOAL_LOGOUT
End Enum

Enum ENUM_DELAY_TO_RETRY
    DELAY_TO_RETRY_NONE
    DELAY_TO_RETRY_DOT1X
    DELAY_TO_RETRY_TUNET
End Enum

Dim gGoal As ENUM_GOAL
Dim gNetworkErrorCount As Long
Dim gDot1xRetryCount As Long
Dim gTunetRetryCount As Long
Dim gDelayToRetry As ENUM_DELAY_TO_RETRY
'Dim gLastRefreshMoneyTime As Date

Dim gNeedResetUsername As Boolean

Public Sub UpdateGUIByCurrentAccountConfig()
    Dim S As String
    Dim i As Long
    
    On Error Resume Next
    cmbUsername.ListIndex = -1
    With CurrentAccountConfig
        i = EthcardName2Idx(.szAdapter)
        If i <> -1 Then cmbAdapter.ListIndex = i
        
        S = .szUserName
        
        cmbUsername.Text = S
        
        chkUseDot1x.value = .bUseDot1x
        
        S = .szPassword
        cmbLimitation.ListIndex = Limitation2Idx(.nLimitation)
        txtPassword.Text = S
    End With
    On Error GoTo 0
End Sub


Private Sub chkSaveUsernamePassword_Click()
    DefaultConfig("SaveUsernamePassword") = chkSaveUsernamePassword.value
    
    If chkSaveUsernamePassword.value = 0 Then
        On Error Resume Next
        DeleteSetting "MyTunet", "Default", "Username"
        DeleteSetting "MyTunet", "Default", "Password"
    End If
End Sub

Private Sub cmbAdapter_Click()
    CurrentAccountConfig.szAdapter = EthCards(cmbAdapter.ListIndex).szName
End Sub

Private Sub cmbLimitation_Click()
    If Idx2Limitation(cmbLimitation.ListIndex) = LIMITATION_NONE Then txtPassword.Text = ""
End Sub

Private Sub cmbUsername_Click()
    Debug.Print cmbUsername.ListIndex
    If cmbUsername.ListIndex <> -1 Then
        CurrentAccountConfig = LoadAccountConfig(cmbUsername.List(cmbUsername.ListIndex))
        UpdateGUIByCurrentAccountConfig
    End If
    
    gNeedResetUsername = True
End Sub

Private Sub cmdShowHideMessages_Click()
    If GetDefaultConfig("ShowMessages", 0) = 0 Then
        DefaultConfig("ShowMessages") = 1
    Else
        DefaultConfig("ShowMessages") = 0
    End If
    
    ShowHideMessages GetDefaultConfig("ShowMessages", 0)
End Sub


Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyEscape Then
        Me.WindowState = vbMinimized
    End If
End Sub

Private Sub mnuCancelShut_Click()
    On Error Resume Next
    Shell "shutdown.exe -a", vbHide
    On Error GoTo 0
    tmrAutoShutReminder.Enabled = False
End Sub

Private Sub mnuIPSwitcher_Click()
    On Error Resume Next
    Shell AppPath + "tools\ipswitcher.exe", vbNormalFocus
    On Error GoTo 0
End Sub

Private Sub mnuWindowsDot1x_Click()
    On Error Resume Next
    Shell AppPath + "tools\win802.1x.exe", vbNormalFocus
    On Error GoTo 0
End Sub

Private Sub tmrAutoShutReminder_Timer()

    'If vbMonday <= Weekday(Date) And Weekday(Date) <= vbFriday And Timer >= 82500 Then
    'vbSunday, vbMonday ... vbThursday

    If (Weekday(Date) < vbFriday) And (82500 <= Timer) And (Timer <= 82800) Then        ' 82500 -> 22:55, 82800 -> 23:00
        frmAutoShutReminder.Show
    End If
  
End Sub

Private Sub tmrServiceTimer_Timer()
    Dim hLog As Long
    Dim tag As String, str As String, data() As Byte

    If MyTunetSvcIsInstalled Then
    
RefetchMyTunetSvcLog:
        hLog = MyTunetSvcGetLogByMailSlot(MyTunetSvcLogsMailSlotHandle)
            
        If hLog Then
            VBMyTunetLogParse hLog, tag, str, data
            MyTunetLogFree hLog
        
            TranslateMyTunetLog Me, tag, str, data
            
            If tag = "TUNET_KEEPALIVE_MONEY" Then AccountMoney = str
            If tag = "TUNET_KEEPALIVE_USED_MONEY" Then AccountUsedMoney = str
            If tag = "TUNET_LOGON_MONEY" Then
                AccountMoney = str
                AccountUsedMoney = "0.00"
            End If
                    
            GoTo RefetchMyTunetSvcLog
        End If
        
        cmdLogin.Enabled = True
        cmdLogout.Enabled = True
    End If
End Sub

Private Sub tmrUpdateTimer_Timer()
    frmMain.tmrUpdateTimer.Enabled = False
    gCheckUpdate = False
    
    'CheckUpdate
    'MsgBox """" + AppPath + App.EXEName + ".exe" + """" + " -checkupdate"
    On Error Resume Next
    Shell """" + AppPath + App.EXEName + ".exe" + """" + " -checkupdate", vbMinimizedNoFocus
    On Error GoTo 0
End Sub

Private Sub txtPassword_Change()
    CurrentAccountConfig.bIsPasswordMD5 = 0
End Sub

Private Sub txtPassword_GotFocus()
    txtPassword.Text = ""
End Sub

Private Sub txtPassword_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        KeyCode = 0
        cmdLogin.SetFocus
        txtPassword_LostFocus
        cmdLogin_Click
    End If
End Sub

Private Sub txtPassword_LostFocus()
    Dim S As String
    If CurrentAccountConfig.bIsPasswordMD5 Then Exit Sub
    If CurrentAccountConfig.bUseMD5 = 0 Then Exit Sub
    
    If txtPassword.Text = "" Then Exit Sub
    
    txtPassword.Text = MD5String(txtPassword.Text)
    
    CurrentAccountConfig.bIsPasswordMD5 = 1
End Sub


Private Sub cmdAbout_Click()
    frmAbout.Show
End Sub

Private Sub cmdConfig_Click()
    frmConfig.Show
End Sub

Private Sub cmdExit_Click()
    Unload Me
End Sub

Private Sub cmdHelp_Click()
    'ShellExecute 0, "open", AppPath + "help\windows.html", "", "", 5
    On Error Resume Next
    HtmlHelp Me.hwnd, AppPath + "help\mytunet.chm", 0, 0
    On Error GoTo 0
End Sub

Public Sub cmdLogin_Click()
    If cmbUsername.Text = "" Or txtPassword.Text = "" Then
        MessageBox 0, tr("Please input your username and password."), "MyTunet", vbExclamation
        Exit Sub
    End If
    

    On Error Resume Next
    Kill "C:\MyTunet.txt"
    On Error GoTo 0
    Err.Clear
    
    If MyTunetSvcIsInstalled Then
        'MyTunet服务模式
        
    Else
        '普通模式
        cmdLogin.Enabled = False
        cmdLogout.Enabled = True
    
        
        If TunetGetState <> TUNET_STATE_NONE And TunetGetState <> TUNET_STATE_LOGOUT Then
            '如果处于登陆状态，则先注销
            '考虑到网络可能会有问题，设置5秒超时
            TunetLogout
        End If
    End If
    
    With CurrentAccountConfig
        If cmbAdapter.ListIndex <> -1 Then
            .szAdapter = EthCards(cmbAdapter.ListIndex).szName
        Else
            .szAdapter = ""
        End If
        'Debug.Print .szAdapter
        If .szAdapter <> "" Then
            If IsWindowsDot1xOpen(.szAdapter) Then
                MessageBox 0, tr("MyTunet has detected that the 802.1x Authentication of Windows is active, which will be in conflict with Tunet 802.1x Authentication. Please close it manually. You can see MyTunet Help or Tunet Offical Website for details."), "MyTunet", vbCritical
                cmdLogin.Enabled = True
                cmdLogout.Enabled = False
                Exit Sub
            End If
            
        End If
        
        .szUserName = cmbUsername.Text
        .szPassword = txtPassword.Text

        .bUseDot1x = chkUseDot1x.value
        .nLimitation = Idx2Limitation(cmbLimitation.ListIndex)
        
        SaveAccountConfig CurrentAccountConfig
        
        MyTunetSetUserConfig .szUserName, .szPassword, .bUseMD5, .szAdapter, .nLimitation, Val(GetDefaultConfig("Language", "0"))
        MyTunetSetUserConfigDot1x .bUseDot1x, .bRetryDot1x
        
        If MyTunetSvcIsInstalled Then
            'MyTunet 服务模式
            MyTunetSvcSetUserConfig .szUserName, .szPassword, .bUseMD5, .szAdapter, .nLimitation, Val(GetDefaultConfig("Language", "0"))
            MyTunetSvcSetUserConfigDot1x .bUseDot1x, .bRetryDot1x
        Else
            MyTunetSvcSetUserConfig "", "", 0, "", 0, 0
            MyTunetSvcSetUserConfigDot1x 0, 0
        End If
    End With
    
    
    If MyTunetSvcIsInstalled Then
        'MyTunet服务模式
        If MyTunetSvcLogin = -1 Then
            If MyTunetSvcStart = -1 Then
                MessageBox 0, tr("MyTunetSvc doesn't run correctly."), "MyTunet", vbCritical
            End If
        End If
    Else
        '普通模式
        AccountMoney = ""
        gNetworkErrorCount = 0
        gDot1xRetryCount = 0
        gTunetRetryCount = 0
        
        
        
        AddLog LOG_LEVEL_3, "[GUI] ===========================" + vbNewLine
        AddLog LOG_LEVEL_3, tr("[GUI] Logon configruation:") + vbNewLine
        
        Dim aidx As Long
        aidx = EthcardName2Idx(CurrentAccountConfig.szAdapter)
        If aidx <> -1 Then
            AddLog LOG_LEVEL_3, tr("[GUI]   Username: ") + cmbUsername.Text + vbNewLine
            AddLog LOG_LEVEL_3, tr("[GUI]   Network adapter: ") + EthCards(aidx).szDesc + vbNewLine
            AddLog LOG_LEVEL_3, tr("[GUI]   Network adapter name: ") + EthCards(aidx).szName + vbNewLine
            AddLog LOG_LEVEL_3, tr("[GUI]   MAC: ") + EthCards(aidx).szMac + vbNewLine
            AddLog LOG_LEVEL_3, tr("[GUI]   IP: ") + EthCards(aidx).szIp + vbNewLine
            
            If (Left(EthCards(aidx).szIp, 8) <> "166.111.") And _
                (Left(EthCards(aidx).szIp, 6) <> "59.66.") Then
                MessageBox 0, tr("MyTunet thinks that your IP is not correct. If you are sure that you are right, please contact with the authors or update your MyTunet."), "MyTunet", vbCritical
            End If
        Else
            AddLog LOG_LEVEL_3, tr("[GUI]   Cannot get find network adapter!") + vbNewLine
        End If
        AddLog LOG_LEVEL_3, "[GUI] ===========================" + vbNewLine
        
        TunetReset
        If chkUseDot1x.value And Dot1xGetState <> DOT1X_STATE_SUCCESS Then
            '如果需要 802.1x 认证，并且还没通过认证，则进行802.1x登陆
            Dot1xReset
            Dot1xLogin
        Else
            TunetLogin
        End If
    End If
End Sub

Public Sub cmdLogout_Click()
    If MyTunetSvcIsInstalled Then
        'MyTunet服务模式
        gGoal = GOAL_LOGOUT
        
        MyTunetSvcLogout
    Else
        '普通模式

        cmdLogin.Enabled = True
        cmdLogout.Enabled = False
        
        TunetLogout
        Dot1xLogout
        
        gGoal = GOAL_NONE
    End If
End Sub


Public Sub RefreshAccountList()
    Dim C As Long, i As Long, S As String, un As String
    C = GetDefaultConfig("AccountCount", 0)
    un = cmbUsername.Text
    cmbUsername.Clear
    
    
    On Error Resume Next
    i = 1
    Err.Clear
    Do While Err = 0
        Unload mnuAccount(i)
        i = i + 1
    Loop
    Err.Clear
    On Error GoTo 0
    
    For i = 1 To C
         cmbUsername.AddItem GetDefaultConfig("Account" & i, "")
         Load mnuAccount(i)
         mnuAccount(i).Caption = GetDefaultConfig("Account" & i, "")
         mnuAccount(i).Visible = True
         mnuAccount(i).Enabled = True
    Next
    cmbUsername.Text = un
End Sub

Private Sub Form_Load()
    ' Re-position form controls to fit window in odd environments
    Dim r As Single
    r = imgMyTunet.Picture.Height / imgMyTunet.Picture.Width
    imgMyTunet.Width = Me.ScaleWidth
    imgMyTunet.Height = imgMyTunet.Width * r
    imgMyTunet.Stretch = True
    With Line2
        .X1 = 1
        .Y1 = lblStatus.Top - 5
        .X2 = Me.ScaleWidth - 1
        .Y2 = .Y1
    End With
    With Line1
        .X1 = Line2.X1
        .Y1 = Line2.Y1 - 1
        .X2 = Line2.X2
        .Y2 = .Y1
    End With
    With lnBottom
        .X1 = 1
        .Y1 = lblStatus.Top + lblStatus.Height + 3
        .X2 = Line2.X2
        .Y2 = .Y1
        .Visible = False
    End With
    ' END OF PATCH
    
    
    On Error Resume Next
    optLanguage(Val(GetDefaultConfig("Language", "1"))).value = True
    On Error GoTo 0
    If Err Then
        optLanguage(0).value = True
        Err.Clear
    End If
        
    If GetDefaultConfig("AutoRun", 1) <> 0 Then SetAutorun True
    
    EnumWindows AddressOf CheckTUNetWindowsProc, 0
    'Dim lngLastErr  As Long
    'TunetMutex = CreateMutex(ByVal 0, 0, TUNET_MUTEX_NAME)
    'lngLastErr = GetLastError()
    'If (lngLastErr = ERROR_ALREADY_EXISTS Or TunetMutex = 0) Or TunetWindowExists Then
    '    MessageBox 0, tr("Another MyTunet or Tunet is running."), "MyTunet", vbInformation
    '    CloseHandle TunetMutex
    '    End
    'End If
    TunetMutex = MyTunetCreateMutex()
    If TunetMutex = 0 Then
        MessageBox 0, tr("Another MyTunet or Tunet is running."), "MyTunet", vbInformation
        End
    End If
    
    Load frmBackground

    Dim i As Long
    Dim NextCheckUpdate As Long
    
    
    
    RefreshEthcards
    RefreshLimitations
    

    
    chkSaveUsernamePassword.value = GetDefaultConfig("SaveUsernamePassword", "1")
    
    For i = 0 To EthCardCount - 1
        cmbAdapter.AddItem EthCards(i).szDesc
    Next
    
    SetLimitationsList cmbLimitation
    
    If cmbAdapter.ListCount = 0 Then
        MsgBox tr("MyTunet cannot get your network adapters!"), vbCritical
    Else
        cmbAdapter.ListIndex = 0
    End If
        
        
    txtPassword_LostFocus
    
    mnuPopup.Visible = False
    
    RefreshAccountList

    
    
    CurrentAccountConfig = LoadAccountConfig
    
    UpdateGUIByCurrentAccountConfig
        
        
    gGoal = GOAL_NONE
    gDelayToRetry = DELAY_TO_RETRY_NONE
    

    
    Show
    DoEvents
    
    ShowHideMessages GetDefaultConfig("ShowMessages", 0)
    
    If MyTunetSvcIsInstalled Then
        'MyTunet服务模式
        If Trim(LCase(Command)) = "autorun" Then
            'Me.Hide
            Me.WindowState = vbMinimized
        End If
    Else
        
        cmdLogin.Enabled = True
        cmdLogout.Enabled = False
        
        If Val(GetDefaultConfig("AutoLogin", "0")) <> 0 Then cmdLogin_Click
    End If
    
    MyTunetSvcLogsMailSlotHandle = MyTunetSvcCreateLogsMailSlot
    
    '设定自动关机提醒计时器状态
    tmrAutoShutReminder.Enabled = Val(GetDefaultConfig("AutoShutReminder", "0"))
    
    '自动检查更新
    If GetDefaultConfig("CheckUpdate", 0) Then
        gCheckUpdate = True
    End If
End Sub

Private Sub ShowHideMessages(ByVal sh As Long)
    On Error Resume Next
    If sh = 0 Then
        Me.Height = (Me.Height / Screen.TwipsPerPixelY - Me.ScaleHeight + lnBottom.Y1) * Screen.TwipsPerPixelY
    Else
        Me.Height = (Me.Height / Screen.TwipsPerPixelY - Me.ScaleHeight + txtLogs.Top + txtLogs.Height + 2) * Screen.TwipsPerPixelY
    End If
    On Error GoTo 0
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If UnloadMode = vbFormControlMenu Then
        Me.WindowState = vbMinimized
        Cancel = 1
    End If
End Sub

Private Sub Form_Resize()
    If Me.WindowState = vbMinimized Then
        Me.Hide
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    'Wait for them to finish stopping
    On Error Resume Next
    'SetGUIBackgroundWindow 0
    
    CloseHandle MyTunetSvcLogsMailSlotHandle
    CloseHandle TunetMutex
    MyTunetSvcLogsMailSlotHandle = 0
    
    Hide
    DoEvents
    
    Dim f As Form
    For Each f In Forms
        Unload f
    Next
    On Error GoTo 0
    
    If MyTunetSvcIsInstalled Then
        'MyTunet服务模式
        '并不终止服务的登陆。只退出GUI程序
    Else
        '普通模式
        gGoal = GOAL_LOGOUT
        TunetStop 2000, 0, 0
    End If
    
    'On Error Resume Next
    'End
End Sub

Private Sub mnuExit_Click()
    cmdExit_Click
End Sub

Private Sub mnuShowHide_Click()
    If Me.Visible Then
        Me.WindowState = vbMinimized
    Else
        Me.WindowState = vbNormal
        Me.Show
    End If
End Sub

Private Sub mnuAccount_Click(Index As Integer)
    cmbUsername.ListIndex = Index - 1
    Debug.Print Index, cmbUsername.ListIndex
    If txtPassword.Text <> "" Then
        cmdLogin_Click
    End If
End Sub

Private Sub optLanguage_Click(Index As Integer)
    DefaultConfig("Language") = Index
    Select Case Index
        Case 0
            LoadTranslation ""
        Case 1
            LoadTranslation "zh_CN"
    End Select
    
    Dim f As Form
    For Each f In Forms
        trForm f
    Next
End Sub











Private Sub TunetLogin()
    'gLastRefreshMoneyTime = Now
    gGoal = GOAL_LOGIN
    TunetStart
End Sub


Private Sub TunetLogout()
    gGoal = GOAL_NONE
    TunetStop 2000, AddressOf MyDoEvents, 0
    gGoal = GOAL_LOGOUT
End Sub


'Private Sub TunetRefreshMoney()
'    '停止后系统会自动重连
'    '然后就可以刷新余额'
'
'    gLastRefreshMoneyTime = Now
'    TunetStop 2000, AddressOf MyDoEvents, 0
'End Sub

Private Sub Dot1xLogin()
    gGoal = GOAL_NONE
    Dot1xStart
    gGoal = GOAL_LOGIN
End Sub

Private Sub Dot1xLogout()
    
    gGoal = GOAL_NONE
    Dot1xStop
    gGoal = GOAL_LOGOUT
    
    gDot1xRetryCount = 0
End Sub





Public Sub AddLog(ByVal LogLevel As ENUM_LOG_LEVEL, ByVal S As String)

    If Val(GetDefaultConfig("SaveLogs", "0")) <> 0 Then
        Dim fn As Long
        On Error Resume Next
        fn = FreeFile
        Open "C:\MyTunet.txt" For Append As fn
        'Print #1, Now, tag, str, Buf2Hex(data, True, False)
        Print #fn, S;
        Close fn
        On Error GoTo 0
    End If
    
    If LogLevel < GetDefaultConfig("ShowLogsLevel", 2) Then Exit Sub
    
    txtLogs.SelLength = 0
    txtLogs.SelStart = Len(txtLogs.Text)
    txtLogs.SelText = S
    txtLogs.SelLength = 0
    txtLogs.SelStart = Len(txtLogs.Text)
    

    If Len(txtLogs.Text) > 60000 Then txtLogs.Text = ""
End Sub


Private Sub DelayToRetry(ByVal r As ENUM_DELAY_TO_RETRY)
    gDelayToRetry = r
    tmrDelayToRetry.Enabled = True
End Sub

Private Sub tmrDelayToRetry_Timer()
    Select Case gDelayToRetry
        Case DELAY_TO_RETRY_DOT1X
        
            If Dot1xGetState = DOT1X_STATE_NONE Or Dot1xGetState = DOT1X_STATE_FAILURE Then
                '重新进行 802.1x 认证
                AddLog LOG_LEVEL_3, tr("[GUI]    Retry to start 802.1x ...") + vbNewLine
                
                gDot1xRetryCount = gDot1xRetryCount + 1
                
                '清除原来的tunet重试记录
                gTunetRetryCount = 0
                Dot1xLogin
            End If
            
        Case DELAY_TO_RETRY_TUNET
            If CurrentAccountConfig.bUseDot1x = 0 Or Dot1xGetState = DOT1X_STATE_SUCCESS Then
                If TunetGetState = TUNET_STATE_ERROR Or TunetGetState = TUNET_STATE_FAILURE _
                   Or TunetGetState = TUNET_STATE_NONE Then
                    '重新进行 tunet 登陆
                    AddLog LOG_LEVEL_3, tr("[GUI]    Retry to start tunet ...") + vbNewLine
                    gTunetRetryCount = gTunetRetryCount + 1
                    TunetLogin
                End If
            End If
    End Select
    
    gDelayToRetry = DELAY_TO_RETRY_NONE
    tmrDelayToRetry.Enabled = False
End Sub

Private Sub tmrRealTimer_Timer()

    '由于ComboBox无法在Click的同时设置Text内容，所以当时只做了个标记，在这里进行实际设置
    If gNeedResetUsername Then
        cmbUsername.Text = CurrentAccountConfig.szUserName
        gNeedResetUsername = False
    End If
    
    Dim data() As Byte
    Dim tag As String
    Dim str As String
    
    Dim bTunetSuccess As Boolean, bDot1xSuccess As Boolean, bTunetFailure As Boolean, bDot1xFailure As Boolean, bNetworkError As Boolean
    
    Dim bKeepAliveError As Boolean
    
    If MyTunetSvcIsInstalled Then Exit Sub  ' 以下代码都是用于GUI登陆的反馈与控制。
    
    
ReMyTunetLogFetch:
        
    bTunetSuccess = False
    bDot1xSuccess = False
    bTunetFailure = False
    bDot1xFailure = False
    bNetworkError = False
    bKeepAliveError = False
    
    If VBMyTunetLogFetch(tag, str, data) Then

        TranslateMyTunetLog Me, tag, str, data
        
        If tag = "DOT1X_RECV_PACK" Then
            If str = "EAP_SUCCESS" Then bDot1xSuccess = True
            If str = "EAP_FAILURE" Then bDot1xFailure = True
        End If
        
        If tag = "TUNET_NETWORK_ERROR" Then bNetworkError = True
        If tag = "TUNET_LOGON_ERROR" Then bTunetFailure = True
        If tag = "TUNET_LOGON_KEEPALIVE_SERVER" Then bTunetSuccess = True
        If tag = "TUNET_KEEPALIVE_MONEY" Then AccountMoney = str
        If tag = "TUNET_KEEPALIVE_USED_MONEY" Then AccountUsedMoney = str
        If tag = "TUNET_LOGON_MONEY" Then
            AccountMoney = str
            AccountUsedMoney = "0.00"
        End If
        If tag = "TUNET_KEEPALIVE_ERROR" Then bKeepAliveError = True
        
        '处理用户界面反馈（图标闪烁）
        If tag <> "" Then
            If Left(tag, Len("TUNET_KEEPALIVE_")) <> "TUNET_KEEPALIVE_" Then
                UpdateTrayIconStatus
            Else
                UpdateTrayIconStatus , TUNET_STATE_forvb_KEEPALIVE_CONFIRM
            End If
        End If
        
        
    
        If gGoal = GOAL_LOGIN Then
            '目标是登陆
            
            
            'TCP网络发生错误
            If bNetworkError Then
                gNetworkErrorCount = gNetworkErrorCount + 1
                
                TunetReset
                If CurrentAccountConfig.bUseDot1x <> 0 Then
                    Dot1xReset
                    DelayToRetry DELAY_TO_RETRY_DOT1X
                Else
                    DelayToRetry DELAY_TO_RETRY_TUNET
                End If
            End If
        
            '在保持活动的时候发生错误
            If bKeepAliveError Then
                TunetReset
                If CurrentAccountConfig.bUseDot1x <> 0 And Dot1xGetState() <> DOT1X_STATE_SUCCESS Then
                    Dot1xReset
                    DelayToRetry DELAY_TO_RETRY_DOT1X
                Else
                    DelayToRetry DELAY_TO_RETRY_TUNET
                End If
            End If
            
            'Tunet登陆错误，把出错消息反馈给用户
            If bTunetFailure Then
                MessageBox 0, str, tr("MyTunet Error Message"), vbCritical
            End If
        
            If bDot1xSuccess Then
                gDot1xRetryCount = 0
            End If
            
            If bTunetSuccess Then
                gTunetRetryCount = 0
                gNetworkErrorCount = 0
                
                '准备启动更新检查
                If gCheckUpdate = True Then tmrUpdateTimer.Enabled = True
                
                '自动隐藏
                If Val(GetDefaultConfig("AutoHide", "0")) <> 0 Then
                    Me.WindowState = vbMinimized
                End If
            End If
    
            
            If bDot1xFailure Then
                'If CurrentAccountConfig.bUseDot1x Then
                '    If CurrentAccountConfig.bRetryDot1x = 0 Then
                '        '如果 802.1x失败，而不指定重试的话，提示错误
                '        MessageBox 0, tr("Fail to authenticate your 802.1x port."), "MyTunet", vbCritical
                '        'cmdLogout_Click
                '    End If
                'End If
            End If
            
            
            If gNetworkErrorCount >= 50 Then
                gNetworkErrorCount = 0
                cmdLogout_Click
            End If
            
        End If
        
        If gGoal = GOAL_LOGOUT Then
            '目标是注销，这时候可以忽略所有错误
            
        End If
        
        
        
        GoTo ReMyTunetLogFetch   '获取所有的日志
        
    End If
    
    
            
    
    
    If gGoal = GOAL_LOGIN Then
        If CurrentAccountConfig.bUseDot1x Then
            '起用802.1x认证的时候
            '如果802.1x连接成功，而Tunet连接还是空闲状态，则……
            If Dot1xGetState = DOT1X_STATE_SUCCESS And TunetGetState = TUNET_STATE_NONE Then
    
                If gTunetRetryCount = 0 Then
                    '从来没重试过，这是第一次登陆tunet，直接登陆
                    gTunetRetryCount = 1
    
                    TunetLogin
                Else
                    Dot1xReset
                    DelayToRetry DELAY_TO_RETRY_DOT1X
                End If
            End If

            '802.1x 是否超时？
            If Dot1xIsTimeout Then
                Dot1xReset
                DelayToRetry DELAY_TO_RETRY_DOT1X
            End If
        End If
            
        
        If TunetIsKeepaliveTimeout Then
            TunetReset
            If CurrentAccountConfig.bUseDot1x Then
                Dot1xStart
            Else
                TunetStart
            End If
        End If
        
        
        
        '最低余额警告
        If Val(AccountMoney) - Val(AccountUsedMoney) <= CurrentAccountConfig.fWarnMoney And AccountUsedMoney <> "" And AccountMoney <> "" Then
            cmdLogout_Click
            MessageBox 0, tr("Lowest Balance Reached! Lowest Balance Protection! Logout!"), "MyTunet", vbExclamation
        End If
    End If
End Sub

