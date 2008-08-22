Attribute VB_Name = "modMyTunetLogs"
Option Explicit

Public Function VBMyTunetLogParse(ByVal hLog As Long, tag As String, str As String, data() As Byte) As Boolean
    Dim nulldata() As Byte
    Dim l  As Long
    
    If hLog <> 0 Then
        tag = Space(1000)
        MyTunetLog_GetTag hLog, tag
        tag = Left(tag, InStr(tag, Chr(0)) - 1)
        
        l = MyTunetLog_GetStringLen(hLog)
        str = ""
        If l <> 0 Then
            str = Space(l + 1)
            MyTunetLog_GetString hLog, str
            str = Left(str, InStr(str, Chr(0)) - 1)
        End If
        
        l = MyTunetLog_GetDataLen(hLog)
        data = nulldata
        If l <> 0 Then
            ReDim data(l - 1)
            MyTunetLog_GetData hLog, data(0)
        End If
        
        VBMyTunetLogParse = True
    Else
        tag = ""
        str = ""
        data = nulldata
        VBMyTunetLogParse = False
    End If
End Function
Public Function VBMyTunetLogFetch(tag As String, str As String, data() As Byte) As Boolean
    Dim hLog As Long
    hLog = MyTunetLogFetch
    If hLog Then
        VBMyTunetLogParse hLog, tag, str, data
        MyTunetLogFree hLog
        
        VBMyTunetLogFetch = True
    Else
        VBMyTunetLogFetch = False
    End If
End Function


Public Sub TranslateMyTunetLog(frm As Form, ByVal tag As String, ByVal str As String, data() As Byte)

    
    Select Case tag
    
        '====================================================
        
        '                    802.1x
        
        '====================================================
        Case "DOT1X_START"
            frm.AddLog LOG_LEVEL_3, tr("[802.1x] Starting ...") + vbNewLine
            
        Case "DOT1X_START_FAIL"         'str
            frm.AddLog LOG_LEVEL_3, tr("[802.1x] Failed to start 802.1x, error occurs when : ") + str + vbNewLine
            
        
        Case "DOT1X_STOP"
            If str <> "" Then
                frm.AddLog LOG_LEVEL_3, tr("[802.1x] Stopped!") + vbNewLine
            Else
                frm.AddLog LOG_LEVEL_3, tr("[802.1x] Stopping ...") + vbNewLine
            End If
            
        Case "DOT1X_RESET"
            frm.AddLog LOG_LEVEL_3, tr("[802.1x] Reset!") + vbNewLine
            
        Case "DOT1X_LOGOUT"   'data
            frm.AddLog LOG_LEVEL_2, tr("[802.1x] Sent logout request.") + vbNewLine
            frm.AddLog LOG_LEVEL_0, "[802.1x]     send: " + Buf2Hex(data, , False) + vbNewLine
            
        Case "DOT1X_LOGON_REQUEST"   ' data
            frm.AddLog LOG_LEVEL_2, tr("[802.1x] Sent logon request.") + vbNewLine
            frm.AddLog LOG_LEVEL_0, "[802.1x]     send: " + Buf2Hex(data, , False) + vbNewLine
            
        Case "DOT1X_LOGON_SEND_USERNAME"   'data
            frm.AddLog LOG_LEVEL_2, tr("[802.1x] Sent username.") + vbNewLine
            frm.AddLog LOG_LEVEL_0, "[802.1x]     send: " + Buf2Hex(data, , False) + vbNewLine
        
        Case "DOT1X_LOGON_AUTH"         'data
            frm.AddLog LOG_LEVEL_2, tr("[802.1x] Sent authentication data.") + vbNewLine
            frm.AddLog LOG_LEVEL_0, "[802.1x]     send: " + Buf2Hex(data, , False) + vbNewLine
        
        Case "DOT1X_RECV_PACK"      'str
            Select Case str
                Case "EAP_REQUEST"
                    frm.AddLog LOG_LEVEL_2, tr("[802.1x] Received request from server ...") + vbNewLine
                Case "EAP_REQUEST(AUTH)"
                    frm.AddLog LOG_LEVEL_2, tr("[802.1x] Received authentication request from server ...") + vbNewLine
                Case "EAP_RESPONSE"
                    frm.AddLog LOG_LEVEL_2, tr("[802.1x] Received response from server (unexpected for TUNET)...") + vbNewLine
                Case "EAP_SUCCESS"
                    frm.AddLog LOG_LEVEL_3, tr("[802.1x] SUCCESS! The port has been opened") + vbNewLine
                Case "EAP_FAILURE(LOGOUT)"
                    frm.AddLog LOG_LEVEL_3, tr("[802.1x] LOGOUT! The port has been closed") + vbNewLine
                Case "EAP_FAILURE"
                    frm.AddLog LOG_LEVEL_3, tr("[802.1x] FAILURE! Authentication failed") + vbNewLine
                Case Else
                    frm.AddLog LOG_LEVEL_0, tr("[802.1x] UNKNOWN EAP Packet") + vbNewLine
            End Select
            
        Case "DOT1X_RECV_START"
            frm.AddLog LOG_LEVEL_0, tr("[802.1x] Unexpected packet: DOT1X_RECV_START") + vbNewLine
        Case "DOT1X_RECV_LOGOFF"
            frm.AddLog LOG_LEVEL_0, tr("[802.1x] Unexpected packet: DOT1X_RECV_LOGOFF") + vbNewLine
        Case "DOT1X_RECV_KEY"
            frm.AddLog LOG_LEVEL_0, tr("[802.1x] Unexpected packet: DOT1X_RECV_KEY") + vbNewLine
        Case "DOT1X_RECV_ASF_ALERT"
            frm.AddLog LOG_LEVEL_0, tr("[802.1x] Unexpected packet: DOT1X_RECV_ASF_ALERT") + vbNewLine
        Case "DOT1X_RECV_UNKNOWN"
            frm.AddLog LOG_LEVEL_0, tr("[802.1x] Unexpected packet: DOT1X_RECV_UNKNOWN") + vbNewLine
        Case "DOT1X_RECV"
            frm.AddLog LOG_LEVEL_0, "[802.1x]     recv: " + Buf2Hex(data, , False) + vbNewLine
            
            
        '====================================================
        
        '                    tunet
        
        '====================================================
        Case "TUNET_NETWORK_ERROR"  'str
            'SEND_TUNET_USER
            'RECV_WELCOME
            'REPLY_WELCOME
            'RECV_REMAINING_DATA
            'KEEPALIVE
            'SEND_LOGOUT
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  A network error occurs when : ") + str + vbNewLine
            
            
        Case "TUNET_LOGON_SEND_TUNET_USER"   'data
            frm.AddLog LOG_LEVEL_2, tr("[tunet]  Sending logon request ...") + vbNewLine
            frm.AddLog LOG_LEVEL_0, "[tunet]      send: " + Buf2Hex(data, , False) + vbNewLine
        Case "TUNET_LOGON_RECV"  'str  , data
            'WELCOME
            'REMAINING
            Select Case str
                Case "WELCOME"
                    frm.AddLog LOG_LEVEL_2, tr("[tunet]  Receiving WELCOME data ...") + vbNewLine
                Case "REMAINING"
                    frm.AddLog LOG_LEVEL_2, tr("[tunet]  Receiving REMAINING data ...") + vbNewLine
            End Select
            frm.AddLog LOG_LEVEL_0, "[tunet]      recv: " + Buf2Hex(data, , False) + vbNewLine
            
        Case "TUNET_LOGON_WELCOME"  'str
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  Welcome Message:") + vbNewLine
            frm.AddLog LOG_LEVEL_3, str + vbNewLine
            
        Case "TUNET_LOGON_ERROR"   'str
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  Logon Error:") + vbNewLine
            frm.AddLog LOG_LEVEL_3, str + vbNewLine
            
        Case "TUNET_LOGON_REPLY_WELCOME" 'data
            frm.AddLog LOG_LEVEL_2, tr("[tunet]  Replying WELCOME data ...") + vbNewLine
            frm.AddLog LOG_LEVEL_0, "[tunet]      send: " + Buf2Hex(data, , False) + vbNewLine
        
        Case "TUNET_LOGON_KEEPALIVE_SERVER"  'str
            frm.AddLog LOG_LEVEL_1, tr("[tunet]  Keep-alive server is : ") + str + vbNewLine
                            
        Case "TUNET_LOGON_MSG"  'str
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  Logon Message:") + vbNewLine
            frm.AddLog LOG_LEVEL_3, str + vbNewLine
            
        Case "TUNET_LOGON_MSGSERVER"  'str
            frm.AddLog LOG_LEVEL_0, tr("[tunet]  Message server is : ") + str + vbNewLine
            
        Case "TUNET_LOGON_MONEY"  'str
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  Your balance of your account is : ") + str + vbNewLine
                        
        Case "TUNET_LOGON_IPs"
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  The IPs of your logons are : ") + str + vbNewLine
            
        Case "TUNET_LOGON_SERVERTIME"
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  The time of server is : ") + str + vbNewLine
            
        Case "TUNET_LOGON_LASTTIME"
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  The last time when you logon is : ") + str + vbNewLine
            
        Case "TUNET_LOGON_FINISH_MSGSERVER"
            frm.AddLog LOG_LEVEL_2, tr("[tunet]  Finished the connection with message server.") + vbNewLine
            
        Case "TUNET_KEEPALIVE_RECV"
            frm.AddLog LOG_LEVEL_1, tr("[tunet]  Receiving keep-alive data ...") + vbNewLine
            frm.AddLog LOG_LEVEL_0, "[tunet]      recv: " + Buf2Hex(data, , False) + vbNewLine
            
        Case "TUNET_KEEPALIVE_CONFIRM"
            frm.AddLog LOG_LEVEL_1, tr("[tunet]  Keep-alive confirm is required, reply it ...") + vbNewLine
        
        Case "TUNET_KEEPALIVE_MONEY"
            frm.AddLog LOG_LEVEL_1, tr("[tunet]  Your balance of your account is : ") + str + vbNewLine
            
        Case "TUNET_KEEPALIVE_USED_MONEY"  'str
            frm.AddLog LOG_LEVEL_1, tr("[tunet]  The money has been used of your active connection : ") + str + vbNewLine
            
        Case "TUNET_KEEPALIVE_ERROR"
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  Keepalive Error : ") + str + vbNewLine
            
        Case "TUNET_KEEPALIVE_RECV_UNKNOWN"
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  Unexpected packet when keeping-alive") + vbNewLine
            
        Case "TUNET_LOGON_SEND_LOGOUT"
            frm.AddLog LOG_LEVEL_2, tr("[tunet]  Sending logout request ...") + vbNewLine
            frm.AddLog LOG_LEVEL_0, "[tunet]      send: " + Buf2Hex(data, , False) + vbNewLine
        
        Case "TUNET_LOGOUT_RECV"
            frm.AddLog LOG_LEVEL_2, tr("[tunet]  Receiving logout data ...") + vbNewLine
            frm.AddLog LOG_LEVEL_0, "[tunet]      recv: " + Buf2Hex(data, , False) + vbNewLine
            
        Case "TUNET_LOGOUT_MSG"
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  Logout Message :") + vbNewLine
            frm.AddLog LOG_LEVEL_3, str + vbNewLine
            
        Case "TUNET_THREAD_STARTING"
            frm.AddLog LOG_LEVEL_2, tr("[tunet]  Starting tunet thread ...") + vbNewLine
        Case "TUNET_THREAD_EXITING"
            frm.AddLog LOG_LEVEL_2, tr("[tunet]  Exiting tunet thread ...") + vbNewLine
        
        Case "TUNET_ERROR"
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  An error occurs!") + vbNewLine
            
        Case "TUNET_LOGOUT"
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  Your logon has been logged-out") + vbNewLine
        Case "TUNET_STOP"
            If str <> "" Then
                frm.AddLog LOG_LEVEL_3, tr("[tunet]  Stopped!") + vbNewLine
            Else
                frm.AddLog LOG_LEVEL_3, tr("[tunet]  Stopping ...") + vbNewLine
            End If
            
        Case "TUNET_START"
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  Starting ...") + vbNewLine
        
        Case "TUNET_RESET"
            frm.AddLog LOG_LEVEL_3, tr("[tunet]  Reset!") + vbNewLine
            
            
        Case "MYTUNETSVC_LIMITATION"
            CopyMemory MyTunetSvcLimitation, data(0), 4
            
        Case "MYTUNETSVC_STATE"
            UpdateTrayIconStatus data(0), data(1)
            
        Case Else
            Debug.Print "Unknown Log:", tag, str, Buf2Hex(data)
    End Select

End Sub
