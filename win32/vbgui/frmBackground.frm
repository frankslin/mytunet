VERSION 5.00
Begin VB.Form frmBackground 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "MyTunetBackgroundWindow"
   ClientHeight    =   2040
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3015
   Icon            =   "frmBackground.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2040
   ScaleWidth      =   3015
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  '´°¿ÚÈ±Ê¡
   Begin VB.Timer tmrUpdateTrayIcon 
      Interval        =   500
      Left            =   1380
      Top             =   660
   End
   Begin VB.Image imgStatusNoLimitation 
      Height          =   240
      Index           =   1
      Left            =   270
      Picture         =   "frmBackground.frx":014A
      Top             =   1575
      Width           =   240
   End
   Begin VB.Image imgStatusNoLimitation 
      Height          =   240
      Index           =   0
      Left            =   15
      Picture         =   "frmBackground.frx":0294
      Top             =   1575
      Width           =   240
   End
   Begin VB.Image imgStatusDomestic 
      Height          =   240
      Index           =   1
      Left            =   300
      Picture         =   "frmBackground.frx":03DE
      Top             =   1125
      Width           =   240
   End
   Begin VB.Image imgStatusDomestic 
      Height          =   240
      Index           =   0
      Left            =   75
      Picture         =   "frmBackground.frx":0528
      Top             =   1140
      Width           =   240
   End
   Begin VB.Image imgStatusCampus 
      Height          =   240
      Index           =   1
      Left            =   300
      Picture         =   "frmBackground.frx":0672
      Top             =   795
      Width           =   240
   End
   Begin VB.Image imgStatusCampus 
      Height          =   240
      Index           =   0
      Left            =   75
      Picture         =   "frmBackground.frx":07BC
      Top             =   780
      Width           =   240
   End
   Begin VB.Image imgStatusDot1x 
      Height          =   240
      Index           =   1
      Left            =   270
      Picture         =   "frmBackground.frx":0906
      Top             =   405
      Width           =   240
   End
   Begin VB.Image imgStatusDot1x 
      Height          =   240
      Index           =   0
      Left            =   30
      Picture         =   "frmBackground.frx":0A50
      Top             =   390
      Width           =   240
   End
   Begin VB.Image imgStatusNA 
      Height          =   240
      Left            =   120
      Picture         =   "frmBackground.frx":0B9A
      Top             =   90
      Width           =   240
   End
End
Attribute VB_Name = "frmBackground"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    SetNewWndProc Me.hwnd
    SetTrayIcon
End Sub

Private Sub Form_Unload(Cancel As Integer)
    UnsetTrayIcon
    UnsetNewWndProc Me.hwnd
End Sub

Private Sub tmrUpdateTrayIcon_Timer()
    UpdateTrayIconStatus
    
    Set frmMain.picStatus.Picture = LoadPicture("")
    frmMain.picStatus.Cls
    DrawIconEx frmMain.picStatus.hdc, 0, 0, MyTray.hIcon, 16, 16, 0, 0, 3
    frmMain.picStatus.Refresh
    
    frmMain.lblStatus.Caption = MyTray.szTip
End Sub
