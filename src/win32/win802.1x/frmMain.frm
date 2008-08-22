VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "MyTunet 802.1x Util for Windows 64"
   ClientHeight    =   5940
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5475
   BeginProperty Font 
      Name            =   "宋体"
      Size            =   9
      Charset         =   134
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5940
   ScaleWidth      =   5475
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtNDomain 
      BackColor       =   &H80000000&
      Height          =   300
      Left            =   1140
      Locked          =   -1  'True
      TabIndex        =   13
      Top             =   5475
      Width           =   4065
   End
   Begin VB.TextBox txtNPassword 
      BackColor       =   &H80000000&
      Height          =   300
      Left            =   1140
      Locked          =   -1  'True
      TabIndex        =   12
      Top             =   5115
      Width           =   4065
   End
   Begin VB.TextBox txtNUserName 
      BackColor       =   &H80000000&
      Height          =   300
      Left            =   1155
      Locked          =   -1  'True
      TabIndex        =   11
      Top             =   4740
      Width           =   4065
   End
   Begin VB.TextBox txtPassword 
      Height          =   300
      IMEMode         =   3  'DISABLE
      Left            =   1140
      PasswordChar    =   "*"
      TabIndex        =   10
      Top             =   3870
      Width           =   4065
   End
   Begin VB.TextBox txtIP 
      Height          =   300
      Left            =   1140
      TabIndex        =   9
      Top             =   3510
      Width           =   4065
   End
   Begin VB.TextBox txtUsername 
      Height          =   300
      Left            =   1155
      TabIndex        =   8
      Top             =   3135
      Width           =   4065
   End
   Begin VB.TextBox Text1 
      Height          =   2265
      Left            =   180
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   7
      Text            =   "frmMain.frx":0ECA
      Top             =   480
      Width           =   5100
   End
   Begin VB.Label Label9 
      Caption         =   "在Windows802.1x登陆对话窗中所需填写的信息："
      Height          =   225
      Left            =   240
      TabIndex        =   15
      Top             =   4455
      Width           =   4890
   End
   Begin VB.Label Label8 
      Caption         =   "您的网络相关信息："
      Height          =   225
      Left            =   240
      TabIndex        =   14
      Top             =   2820
      Width           =   1680
   End
   Begin VB.Label Label7 
      Caption         =   "使用 Windows 自带的802.1x端口认证登录网络"
      Height          =   255
      Left            =   210
      TabIndex        =   6
      Top             =   165
      Width           =   3930
   End
   Begin VB.Label Label6 
      Caption         =   "密码:"
      Height          =   270
      Left            =   255
      TabIndex        =   5
      Top             =   5160
      Width           =   675
   End
   Begin VB.Label Label5 
      Caption         =   "登陆域:"
      Height          =   225
      Left            =   240
      TabIndex        =   4
      Top             =   5505
      Width           =   765
   End
   Begin VB.Label Label4 
      Caption         =   "用户名:"
      Height          =   225
      Left            =   255
      TabIndex        =   3
      Top             =   4845
      Width           =   765
   End
   Begin VB.Line Line1 
      X1              =   -60
      X2              =   5745
      Y1              =   4305
      Y2              =   4305
   End
   Begin VB.Label Label3 
      Caption         =   "密码:"
      Height          =   270
      Left            =   210
      TabIndex        =   2
      Top             =   3945
      Width           =   675
   End
   Begin VB.Label Label2 
      Caption         =   "IP:"
      Height          =   225
      Left            =   240
      TabIndex        =   1
      Top             =   3555
      Width           =   765
   End
   Begin VB.Label Label1 
      Caption         =   "用户名:"
      Height          =   225
      Left            =   240
      TabIndex        =   0
      Top             =   3225
      Width           =   765
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Function MD5String(ByVal S As String) As String
    Dim md5 As New CMD5
    S = md5.Md5_String_Calc(S)
    S = Replace(S, " ", "")
    S = LCase(S)
    MD5String = S
End Function

Private Sub Form_Load()
    txtUsername.Text = GetSetting("MyTunet", "Win802.1x", "Username", "")
    txtIP.Text = GetSetting("MyTunet", "Win802.1x", "IP", "")
End Sub

Private Sub txtIP_Change()
    txtNUserName.Text = Trim(txtUsername.Text) + "@" + Trim(txtIP.Text)
    SaveSetting "MyTunet", "Win802.1x", "IP", txtIP.Text
End Sub

Private Sub txtNDomain_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyC And Shift = 2 Then
        Clipboard.SetText txtNDomain.Text
    End If
End Sub

Private Sub txtNPassword_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyC And Shift = 2 Then
        Clipboard.Clear
        Clipboard.SetText txtNPassword.Text
    End If
End Sub

Private Sub txtNUserName_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyC And Shift = 2 Then
        Clipboard.Clear
        Clipboard.SetText txtNUserName.Text
    End If
End Sub

Private Sub txtPassword_Change()
    txtNPassword.Text = MD5String(txtPassword)
End Sub

Private Sub txtUsername_Change()
    txtNUserName.Text = Trim(txtUsername.Text) + "@" + Trim(txtIP.Text)
    SaveSetting "MyTunet", "Win802.1x", "Username", txtUsername.Text
End Sub
