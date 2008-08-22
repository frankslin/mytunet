VERSION 5.00
Begin VB.Form frmConfig 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Configuration"
   ClientHeight    =   6150
   ClientLeft      =   1875
   ClientTop       =   2475
   ClientWidth     =   9855
   Icon            =   "frmConfig.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6150
   ScaleWidth      =   9855
   Begin VB.CheckBox chkCheckUpdate 
      Caption         =   "Automatically check the update of MyTunet"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   345
      Left            =   240
      TabIndex        =   38
      Top             =   2010
      Width           =   4725
   End
   Begin VB.CheckBox chkAutoShut 
      Caption         =   "and shut down the computer 2 min later (XP)"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   480
      TabIndex        =   37
      Top             =   1740
      Width           =   4455
   End
   Begin VB.CommandButton cmdFinishConfig 
      Caption         =   "Finish Configuring"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   240
      TabIndex        =   36
      Top             =   5640
      Width           =   9375
   End
   Begin VB.CheckBox chkAutoShutReminder 
      Caption         =   "Shut-down Reminder at 22:55 on Sunday to Thursday"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   240
      TabIndex        =   35
      Top             =   1320
      Width           =   4725
   End
   Begin VB.Frame Frame3 
      Caption         =   "Install as service"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   4095
      Left            =   5040
      TabIndex        =   23
      Top             =   1440
      Width           =   4620
      Begin VB.CommandButton cmdInstallService 
         Caption         =   "Install MyTunet service"
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   345
         Left            =   300
         TabIndex        =   30
         Top             =   2625
         Width           =   4035
      End
      Begin VB.CommandButton cmdStopService 
         Caption         =   "Stop service"
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Left            =   2355
         TabIndex        =   29
         Top             =   3540
         Width           =   1980
      End
      Begin VB.CommandButton cmdStartService 
         Caption         =   "Start service"
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Left            =   300
         TabIndex        =   28
         Top             =   3540
         Width           =   2040
      End
      Begin VB.Timer tmrServiceTimer 
         Interval        =   1000
         Left            =   3960
         Top             =   840
      End
      Begin VB.CommandButton cmdRemoveService 
         Caption         =   "Remove MyTunet service"
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   345
         Left            =   300
         TabIndex        =   27
         Top             =   3105
         Width           =   4035
      End
      Begin VB.Label Label11 
         Caption         =   "HINTS: MyTunet service don't have the features like 'Lowest balance protection' !"
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   480
         Left            =   105
         TabIndex        =   32
         Top             =   1890
         Width           =   4305
      End
      Begin VB.Label Label9 
         Caption         =   "MyTunet service will use your last logon information for the future logons."
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   450
         Left            =   135
         TabIndex        =   31
         Top             =   1230
         Width           =   4380
      End
      Begin VB.Label Label4 
         Caption         =   $"frmConfig.frx":058A
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   810
         Left            =   120
         TabIndex        =   24
         Top             =   270
         Width           =   4365
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Show Logs"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1125
      Left            =   5040
      TabIndex        =   22
      Top             =   195
      Width           =   4620
      Begin VB.CheckBox chkSaveLogs 
         Caption         =   "Save raw logs to C:\MyTunet.txt"
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   240
         TabIndex        =   33
         Top             =   720
         Width           =   3645
      End
      Begin VB.OptionButton optShowLogsLevel 
         Caption         =   "Very Very Important Logs"
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
         Index           =   3
         Left            =   2040
         TabIndex        =   18
         Top             =   510
         Width           =   2460
      End
      Begin VB.OptionButton optShowLogsLevel 
         Caption         =   "Very Important Logs"
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
         Index           =   2
         Left            =   2040
         TabIndex        =   17
         Top             =   240
         Width           =   2460
      End
      Begin VB.OptionButton optShowLogsLevel 
         Caption         =   "Important Logs"
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
         Index           =   1
         Left            =   240
         TabIndex        =   16
         Top             =   510
         Width           =   1785
      End
      Begin VB.OptionButton optShowLogsLevel 
         Caption         =   "All logs"
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
         Index           =   0
         Left            =   240
         TabIndex        =   15
         Top             =   240
         Width           =   1050
      End
   End
   Begin VB.CheckBox chkAutoLogin 
      Caption         =   "Auto-login after launch"
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
      Left            =   240
      TabIndex        =   2
      Top             =   435
      Width           =   3720
   End
   Begin VB.CheckBox chkPopupErrorMessages 
      Caption         =   "Popup error messages"
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
      Left            =   240
      TabIndex        =   4
      Top             =   1020
      Width           =   4110
   End
   Begin VB.CheckBox chkAutoHide 
      Caption         =   "Hide the MyTunet window after logon"
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
      Left            =   240
      TabIndex        =   3
      Top             =   690
      Width           =   4545
   End
   Begin VB.CheckBox chkAutorun 
      Caption         =   "Autorun when Windows starts up"
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
      Left            =   240
      TabIndex        =   1
      Top             =   105
      Width           =   3105
   End
   Begin VB.Frame Frame1 
      Caption         =   "Account List"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3105
      Left            =   240
      TabIndex        =   0
      Top             =   2430
      Width           =   4710
      Begin VB.TextBox txtUsername 
         BeginProperty Font 
            Name            =   "新宋体"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   975
         TabIndex        =   6
         Top             =   615
         Width           =   3555
      End
      Begin VB.TextBox txtWarnMoney 
         Alignment       =   1  'Right Justify
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
         Left            =   2595
         TabIndex        =   12
         Text            =   "-20"
         Top             =   2640
         Width           =   840
      End
      Begin VB.CheckBox chkRetryDot1x 
         Caption         =   "Retry 802.1x Authentication when fail"
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
         Left            =   360
         TabIndex        =   11
         Top             =   2310
         Width           =   3795
      End
      Begin VB.CheckBox chkUseDot1x 
         Caption         =   "Use 802.1x Authentication"
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
         Left            =   360
         TabIndex        =   10
         Top             =   2025
         Width           =   3585
      End
      Begin VB.ComboBox cmbAccountList 
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
         ItemData        =   "frmConfig.frx":0623
         Left            =   990
         List            =   "frmConfig.frx":0625
         TabIndex        =   5
         Top             =   240
         Width           =   2175
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
         ItemData        =   "frmConfig.frx":0627
         Left            =   975
         List            =   "frmConfig.frx":0634
         Style           =   2  'Dropdown List
         TabIndex        =   7
         Top             =   990
         Width           =   3570
      End
      Begin VB.CheckBox chkUseMD5 
         Caption         =   "Use MD5 to encrypt the password"
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
         Left            =   975
         TabIndex        =   9
         Top             =   1740
         Width           =   3300
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
         Height          =   300
         IMEMode         =   3  'DISABLE
         Left            =   975
         PasswordChar    =   "*"
         TabIndex        =   8
         Top             =   1380
         Width           =   3555
      End
      Begin VB.CommandButton cmdRemoveAccount 
         Caption         =   "Remove"
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
         Left            =   3825
         TabIndex        =   14
         Top             =   240
         Width           =   735
      End
      Begin VB.CommandButton cmdSaveAccount 
         Caption         =   "Save"
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
         Left            =   3180
         TabIndex        =   13
         Top             =   240
         Width           =   660
      End
      Begin VB.Label Label10 
         AutoSize        =   -1  'True
         Caption         =   "Lowest balance protection:"
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
         Left            =   120
         TabIndex        =   34
         Top             =   2670
         Width           =   2340
      End
      Begin VB.Label Label8 
         AutoSize        =   -1  'True
         Caption         =   "Account:"
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
         Left            =   150
         TabIndex        =   26
         Top             =   300
         Width           =   720
      End
      Begin VB.Label Label5 
         AutoSize        =   -1  'True
         Caption         =   "RMB"
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
         Left            =   3495
         TabIndex        =   25
         Top             =   2685
         Width           =   270
      End
      Begin VB.Label Label3 
         Caption         =   "Limit:"
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
         Left            =   135
         TabIndex        =   21
         Top             =   1035
         Width           =   510
      End
      Begin VB.Label Label2 
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
         TabIndex        =   20
         Top             =   1440
         Width           =   810
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
         Left            =   135
         TabIndex        =   19
         Top             =   645
         Width           =   810
      End
   End
End
Attribute VB_Name = "frmConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim uc As GUI_ACCOUNTCONFIG

Private Sub chkAutoLogin_Click()
     Config("Default", "AutoLogin") = chkAutoLogin.value
End Sub

Private Sub chkAutoRun_Click()
    SetAutorun chkAutorun.value
    DefaultConfig("AutoRun") = Format(chkAutorun.value)
End Sub

Private Sub chkAutoHide_Click()
    DefaultConfig("AutoHide") = Format(chkAutoHide.value)
End Sub

Private Sub chkAutoShut_Click()
    DefaultConfig("AutoShut") = Format(chkAutoShut.value)
End Sub

Private Sub chkAutoShutReminder_Click()
    DefaultConfig("AutoShutReminder") = Format(chkAutoShutReminder.value)

    chkAutoShut.Enabled = GetDefaultConfig("AutoShutReminder", 0)
    frmMain.tmrAutoShutReminder.Enabled = GetDefaultConfig("AutoShutReminder", 0)
    
    If chkAutoShutReminder.value = False Then chkAutoShut.value = False
End Sub

Private Sub chkCheckUpdate_Click()
    DefaultConfig("CheckUpdate") = Format(chkCheckUpdate.value)
End Sub

Private Sub chkPopupErrorMessages_Click()
    DefaultConfig("PopupErrorMessages") = Format(chkPopupErrorMessages.value)
End Sub

Private Sub chkRetryDot1x_Click()
    uc.bRetryDot1x = chkRetryDot1x.value
End Sub

Private Sub chkSaveLogs_Click()
    DefaultConfig("SaveLogs") = chkSaveLogs.value
End Sub

Private Sub chkUseDot1x_Click()
    uc.bUseDot1x = chkUseDot1x.value
End Sub

Private Sub chkUseMD5_Click()
    
    uc.bUseMD5 = chkUseMD5.value
    
    If uc.bUseMD5 And uc.bIsPasswordMD5 = 0 Then
        txtPassword_LostFocus
    End If
    
    If uc.bUseMD5 = 0 Then txtPassword.Text = ""
End Sub

Private Sub cmbLimitation_Click()
    If Idx2Limitation(cmbLimitation.ListIndex) = LIMITATION_NONE Then txtPassword.Text = ""
End Sub

Private Sub cmbAccountList_Change()
    txtPassword.Text = ""
End Sub

Private Sub cmbAccountList_Click()
    
    Dim szAccount As String
    
    If cmbAccountList.ListIndex = 0 Then
        szAccount = "Default"
    ElseIf cmbAccountList.ListIndex <> -1 Then
        szAccount = cmbAccountList.Text
    End If
    
    uc = LoadAccountConfig(szAccount)
    
    txtUsername.Text = uc.szUserName
    chkUseMD5.value = uc.bUseMD5
    chkUseDot1x.value = uc.bUseDot1x
    chkRetryDot1x.value = uc.bRetryDot1x
    txtWarnMoney.Text = uc.fWarnMoney
    
    If uc.bUseMD5 Then uc.bIsPasswordMD5 = 1
    
    
    Dim S As String
    S = uc.szPassword
    cmbLimitation.ListIndex = Limitation2Idx(uc.nLimitation)
    txtPassword.Text = S
    
    uc.szPassword = S
    

End Sub

Private Sub cmdFinishConfig_Click()
    Unload Me
End Sub

Private Sub cmdInstallService_Click()
    
    If frmMain.txtPassword.Text = "" Or frmMain.cmbUsername.Text = "" Then
        MessageBox 0, tr("Please input your username and password in MyTunet main window."), "MyTunet", vbExclamation
        Exit Sub
    End If
    
    If frmMain.cmdLogout.Enabled Then
        frmMain.cmdLogout_Click
    End If
    MyTunetSvcInstall AppPath + "Svc\MyTunetSvc.exe"
    tmrServiceTimer_Timer
End Sub

Private Sub cmdRemoveAccount_Click()
    If cmbAccountList.ListIndex >= 1 Then
        DeleteSetting "MyTunet", "ACCOUNT-" & cmbAccountList.Text
        
        cmbAccountList.RemoveItem cmbAccountList.ListIndex
        cmbAccountList.ListIndex = 0
        
        Dim C As Long, i As Long, S As String
        C = GetDefaultConfig("AccountCount", 0)
        For i = 1 To C
            DeleteSetting "MyTunet", "Default", "Account" & i
        Next
        
        For i = 1 To cmbAccountList.ListCount - 1
            DefaultConfig("Account" & i) = cmbAccountList.List(i)
        Next
        DefaultConfig("AccountCount") = cmbAccountList.ListCount - 1
        
        For i = 1 To cmbAccountList.ListCount - 1
            DefaultConfig("Account" & i) = cmbAccountList.List(i)
        Next
        DefaultConfig("AccountCount") = cmbAccountList.ListCount - 1
        
        frmMain.RefreshAccountList
    End If
End Sub

Private Sub cmdRemoveService_Click()
    MyTunetSvcRemove
    tmrServiceTimer_Timer
End Sub

Private Sub cmdSaveAccount_Click()
    
    Dim szAccount As String
    
    szAccount = cmbAccountList.Text
    
    
    
    Select Case ComboItem2Index(cmbAccountList, szAccount, -1)
        Case -1
            If Not IsAccountNameValid(szAccount) Then
                MessageBox 0, tr("Account name is invalid. Please check it."), "MyTunet", vbExclamation
                Exit Sub
            End If
            cmbAccountList.AddItem szAccount
            
        Case 0
            szAccount = "Default"
        Case Else
            'we got it
    End Select
    
    
    uc.szUserName = txtUsername.Text
    uc.szPassword = txtPassword.Text
    uc.bUseMD5 = chkUseMD5.value
    uc.bUseDot1x = chkUseDot1x.value
    uc.bRetryDot1x = chkRetryDot1x.value
    uc.nLimitation = Idx2Limitation(cmbLimitation.ListIndex)
    
    uc.fWarnMoney = Val(txtWarnMoney.Text)
        
    SaveAccountConfig uc, szAccount
    
    
    Dim C As Long, i As Long, S As String
    C = GetDefaultConfig("AccountCount", 0)
    For i = 1 To C
        DeleteSetting "MyTunet", "Default", "Account" & i
    Next
    
    For i = 1 To cmbAccountList.ListCount - 1
        DefaultConfig("Account" & i) = cmbAccountList.List(i)
    Next
    DefaultConfig("AccountCount") = cmbAccountList.ListCount - 1
    
    cmbAccountList.ListIndex = ComboItem2Index(cmbAccountList, cmbAccountList.Text, 0)
    
    frmMain.RefreshAccountList
    
    If szAccount = "Default" Then
        CurrentAccountConfig = LoadAccountConfig
        frmMain.UpdateGUIByCurrentAccountConfig
    End If
    
End Sub

Private Sub cmdStartService_Click()
    'MyTunetSvcStart
    frmMain.cmdLogin_Click
    tmrServiceTimer_Timer
End Sub

Private Sub cmdStopService_Click()
    MyTunetSvcStop
    tmrServiceTimer_Timer
End Sub

Private Sub Form_Load()
        
    SetLimitationsList cmbLimitation
    'SetLimitationsList cmbServiceLimitation
    cmbLimitation.ListIndex = 1
    'cmbServiceLimitation.ListIndex = 1
    
    chkAutorun.value = Val(GetDefaultConfig("AutoRun", "1"))
    chkAutoLogin.value = Val(GetDefaultConfig("AutoLogin", "0"))
    chkAutoHide.value = Val(GetDefaultConfig("AutoHide", "1"))
    chkPopupErrorMessages.value = Val(GetDefaultConfig("PopupErrorMessages", "1"))
    chkSaveLogs.value = Val(GetDefaultConfig("SaveLogs", "0"))
    
    chkAutoShutReminder.value = Val(GetDefaultConfig("AutoShutReminder", "0"))
    chkAutoShut.value = Val(GetDefaultConfig("AutoShut", "0"))
    chkAutoShut.Enabled = chkAutoShutReminder.value

    chkCheckUpdate.value = GetDefaultConfig("CheckUpdate", 1)
    
    
    On Error Resume Next
    optShowLogsLevel(Val(GetDefaultConfig("ShowLogsLevel", "2"))).value = True
    On Error GoTo 0
    If Err Then
        optShowLogsLevel(2).value = True
        Err.Clear
    End If
    
    
    
    
    cmbAccountList.AddItem tr("(Current)")
    cmbAccountList.ListIndex = 0
    
    Dim C As Long, i As Long, S As String
    C = GetDefaultConfig("AccountCount", 0)
    For i = 1 To C
        S = GetDefaultConfig("Account" & i, "")
        cmbAccountList.AddItem S
    Next
    
    
    tmrServiceTimer_Timer
    
    trForm Me
End Sub


Private Sub optShowLogsLevel_Click(Index As Integer)
    DefaultConfig("ShowLogsLevel") = Index
End Sub

Private Sub tmrServiceTimer_Timer()
    
    Dim bInstall As Boolean, bRemove As Boolean, bStart As Boolean, bStop As Boolean
    Dim State As Long
    
    State = MyTunetSvcGetState
    
    If MyTunetSvcIsInstalled = 0 Then bInstall = True
    
    If State = SERVICE_STOPPED Then bRemove = True
    
    If State = SERVICE_RUNNING Or State = SERVICE_PAUSED Then bStop = True
    If State = SERVICE_STOPPED Then bStart = True
    
    cmdInstallService.Enabled = bInstall
    cmdRemoveService.Enabled = bRemove
    cmdStartService.Enabled = bStart
    cmdStopService.Enabled = bStop
End Sub

Private Sub txtPassword_Change()
    uc.bIsPasswordMD5 = 0
End Sub

Private Sub txtPassword_GotFocus()
    txtPassword.Text = ""
End Sub

Private Sub txtPassword_LostFocus()
    If uc.bUseMD5 Then
        If txtPassword.Text = "" Or uc.bIsPasswordMD5 Then Exit Sub
        
        txtPassword.Text = MD5String(txtPassword.Text)
        uc.bIsPasswordMD5 = 1
        uc.szPassword = txtPassword.Text
    End If
End Sub

Private Sub txtWarnMoney_MouseMove(Button As Integer, Shift As Integer, X As Single, y As Single)
    txtWarnMoney.SetFocus
End Sub

