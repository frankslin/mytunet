VERSION 5.00
Begin VB.Form frmUpdate 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "MyTunet AutoUpdate"
   ClientHeight    =   5445
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5190
   Icon            =   "frmUpdate.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5445
   ScaleWidth      =   5190
   StartUpPosition =   2  'CenterScreen
   Visible         =   0   'False
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      BeginProperty Font 
         Name            =   "新宋体"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   480
      Left            =   3825
      TabIndex        =   7
      Top             =   4815
      Width           =   1185
   End
   Begin VB.TextBox txtDescription 
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   10.5
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2295
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   780
      Width           =   4875
   End
   Begin VB.Label Label1 
      Caption         =   "You can disable the AutoUpdate feature in MyTunet configuration."
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
      Left            =   105
      TabIndex        =   9
      Top             =   4785
      Width           =   3645
   End
   Begin VB.Label lblVersion 
      Caption         =   ".."
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   10.5
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   2055
      TabIndex        =   8
      Top             =   105
      Width           =   3180
   End
   Begin VB.Label lblOfficalClick 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   10.5
         Charset         =   134
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   210
      Left            =   480
      MouseIcon       =   "frmUpdate.frx":0ECA
      MousePointer    =   99  'Custom
      TabIndex        =   6
      Top             =   4125
      Width           =   105
   End
   Begin VB.Label lblDownloadClick 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   10.5
         Charset         =   134
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   210
      Left            =   480
      MouseIcon       =   "frmUpdate.frx":101C
      MousePointer    =   99  'Custom
      TabIndex        =   5
      Top             =   3525
      Width           =   105
   End
   Begin VB.Label lblDescription 
      AutoSize        =   -1  'True
      Caption         =   "Version Description"
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   10.5
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   210
      Left            =   105
      TabIndex        =   3
      Top             =   510
      Width           =   1995
   End
   Begin VB.Label lblDownloadURL 
      AutoSize        =   -1  'True
      Caption         =   "Download URL"
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   10.5
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   210
      Left            =   120
      TabIndex        =   2
      Top             =   3255
      Width           =   1260
   End
   Begin VB.Label lblOfficialURL 
      AutoSize        =   -1  'True
      Caption         =   "Official URL"
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   10.5
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   210
      Left            =   120
      TabIndex        =   1
      Top             =   3855
      Width           =   1260
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Lastest Version:"
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   10.5
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   210
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1680
   End
End
Attribute VB_Name = "frmUpdate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdClose_Click()
    End
End Sub

Private Sub Form_Load()
    trForm Me
    Me.Caption = tr("MyTunet AutoUpdate : ") + MYTUNET_VERSION
    Beep
End Sub

Private Sub Form_Unload(Cancel As Integer)
    End
End Sub

Private Sub lblDownloadClick_Click()
    ShellExecute 0, "open", lblDownloadClick.ToolTipText, "", "", 5
End Sub

Private Sub lblOfficalClick_Click()
    ShellExecute 0, "open", lblOfficalClick.ToolTipText, "", "", 5
End Sub

