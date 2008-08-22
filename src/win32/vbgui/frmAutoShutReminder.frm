VERSION 5.00
Begin VB.Form frmAutoShutReminder 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "MyTunet 关机提醒"
   ClientHeight    =   1830
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   6705
   Icon            =   "frmAutoShutReminder.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1830
   ScaleWidth      =   6705
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdDoNotShut 
      Caption         =   "请不要关机"
      Height          =   375
      Left            =   3000
      TabIndex        =   3
      Top             =   1200
      Width           =   1455
   End
   Begin VB.CommandButton cmdShutNow 
      Caption         =   "现在就关机"
      Height          =   375
      Left            =   4680
      TabIndex        =   2
      Top             =   1200
      Width           =   1455
   End
   Begin VB.CommandButton cmdISee 
      Caption         =   "我知道了"
      Height          =   375
      Left            =   1320
      TabIndex        =   0
      Top             =   1200
      Width           =   1455
   End
   Begin VB.Image Image1 
      Height          =   660
      Left            =   240
      Picture         =   "frmAutoShutReminder.frx":1CFA
      Top             =   240
      Width           =   570
   End
   Begin VB.Label Label1 
      Caption         =   "紫荆公寓即将熄灯，请保存正在进行的工作，并准备关机。"
      Height          =   375
      Left            =   1200
      TabIndex        =   1
      Top             =   360
      Width           =   4935
   End
End
Attribute VB_Name = "frmAutoShutReminder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)


Private Sub cmdDoNotShut_Click()
    On Error Resume Next
    frmMain.tmrAutoShutReminder.Enabled = False
    Shell "cmd.exe /c shutdown.exe -a", vbHide
    On Error GoTo 0
    Unload Me
End Sub

Private Sub cmdISee_Click()
    frmMain.tmrAutoShutReminder.Enabled = False
    Unload Me

End Sub

Private Sub cmdShutNow_Click()

    frmMain.tmrAutoShutReminder.Enabled = False
    
    On Error Resume Next
    Shell "cmd.exe /c shutdown.exe -a", vbHide
    Sleep 1000
    Shell "cmd.exe /c shutdown.exe -s -t 5 -c MyTunet将立即关机。", vbHide
    On Error GoTo 0
    
    Unload Me

End Sub

Private Sub Form_Load()
    If GetDefaultConfig("AutoShut", 0) <> 0 Then
        On Error Resume Next
        Shell "cmd.exe /c shutdown.exe -s -t 120 -c 紫荆公寓即将熄灯。为防止资料丢失，请保存正在进行的工作，并准备关机。", vbHide
        On Error GoTo 0
    Else
        cmdDoNotShut.Visible = False
        cmdShutNow.Visible = False
    End If
End Sub
