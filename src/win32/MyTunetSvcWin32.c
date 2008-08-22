#include "../ethcard.h"
#include "../os.h"
#include "../mytunet.h"
#include "../des.h"
#include "../md5.h"
#include "../util.h"
#include "../setting.h"
#include "../logs.h"
#include "../userconfig.h"

#include "../dot1x.h"
#include "../tunet.h"
#include "../mytunetsvc.h"

#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include "svchelper.h"

void  WINAPI  ServiceMain(DWORD dwArgc, LPTSTR *lpszArgv);
void  WINAPI  ServiceCtrl(DWORD dwCtrlCode);

void  ErrorStopService(LPTSTR lpszAPI);
void  SetTheServiceStatus(DWORD dwCurrentState,DWORD dwWin32ExitCode,
                          DWORD dwCheckPoint,  DWORD dwWaitHint);


//HANDLE                    g_hStopEvent = INVALID_HANDLE_VALUE;
SERVICE_STATUS_HANDLE   g_ServiceStatus;
//TCHAR                 g_szConfigFile[MAX_PATH];
//USERCONFIG                g_UserConfig;
//HANDLE                    g_hTransmitLogsThread = INVALID_HANDLE_VALUE;

//HANDLE                    hMyTunetDLL = INVALID_HANDLE_VALUE;

enum
{
    GOAL_NONE,
    GOAL_LOGIN,
    GOAL_RELOGIN,
    GOAL_LOGOUT
};

enum
{
    DELAY_RETRY_NONE,
    DELAY_RETRY_DOT1X,
    DELAY_RETRY_TUNET
};

//INT                   g_Goal = GOAL_NONE;
//LOCK              *g_GoalLock = NULL;

//INT                   g_DelayRetry = DELAY_RETRY_NONE;
/*
int DoLogin()
{
    //os_lock_lock(g_GoalLock);

    mytunetsvc_get_user_config(&g_UserConfig);

    //dprintf("bUseDot1x %d\n",  g_UserConfig.bUseDot1x);

    if(g_Goal == GOAL_LOGIN)
    {
        g_Goal = GOAL_RELOGIN;
        g_DelayRetry = DELAY_RETRY_NONE;
    }
    else
        g_Goal = GOAL_LOGIN;

    //os_lock_unlock(g_GoalLock);

    return OK;
}

int DoLogout()
{
    //os_lock_lock(g_GoalLock);

    g_Goal = GOAL_LOGOUT;

    //os_lock_unlock(g_GoalLock);

    return OK;
}


void MyTunetSvc_Init()
{
    //hMyTunetDLL = LoadLibrary("MyTunetDLL.dll");
    //g_GoalLock = os_lock_create();
    mytunet_init();
}

void MyTunetSvc_Cleanup()
{
    mytunet_cleanup();
    //g_GoalLock = os_lock_free(g_GoalLock);
}
*/

int main(int argc, char *argv[])
{
    TCHAR       szBinaryPathName[MAX_PATH];

    SERVICE_TABLE_ENTRY ste[] =
    {
        {TEXT(""),(LPSERVICE_MAIN_FUNCTION)ServiceMain}, {NULL, NULL}
    };

    STARTUPINFOA si;

    INT bRunByUser = 0;
    CHAR *username, *password, *adapter;
    BOOL  usedot1x;
    INT   language, limitation;
    ETHCARD_INFO ethcards[16];
    INT     ethcardcount;
    INT     i;

	DeleteFile("C:\\mytunetsvc.txt");
	

    GetModuleFileName(0, szBinaryPathName, sizeof(szBinaryPathName));

    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);

    GetStartupInfoA(&si);

    if(si.lpDesktop)
    {
        if(strlen(si.lpDesktop) != 0)
            bRunByUser = 1;
        else
            bRunByUser = 0;
    }
    else
    {
        bRunByUser = 0;
    }


    mytunetsvc_set_transmit_log_func(MYTUNETSVC_TRANSMIT_LOG_WIN32);

    mytunetsvc_init();

    if(bRunByUser)
    {
        //dprintf("用户方式启动。\n");

        //printf("username = %s\npassword = %s\n", g_UserConfig.szUsername, g_UserConfig.szMD5Password);
        ethcardcount = get_ethcards(ethcards, sizeof(ethcards));
        if(argc == 1)
        {
            puts( " MyTunet Service Program\n");

            puts(" You Network Devices:");
            for(i = 0;i < ethcardcount; i++)
            {
                printf("    %d. %s\n", i, ethcards[i].desc);
            }
            puts("");

            puts(
                    " Usage: \n"
                    "   MyTunetSvc [install/remove/start/stop]\n"
                    "   MyTunetSvc [login/logout]\n"
                    "   MyTunetSvc set <adapter index> <user> <pwd> <0/1 (need 802.1x?)>\n"
                    "                  <C/E (language)> <C/D/N (Campus/Domestic/NoLimitation)>\n");

            printf("  For example:  MyTunetSvc set 0 wang abcd 1 C D\n"
                   "   \n"
                   "    will set the logon information like this:\n"
                   "     - use the first network device,\n"
                   "     - username is \'wang\',\n"
                   "     - password is \'abcd\',\n"
                   "     - use 802.1x authorization,\n"
                   "     - language is Chinese,\n"
                   "     - open the connection for Domestic.\n");

        }
        else
        {
            if(strcmp(argv[1], "install") == 0)
            {
                return MyTunetSvcInstall(szBinaryPathName);
            }
            if(strcmp(argv[1], "remove") == 0)
            {
                return MyTunetSvcRemove();
            }
            if(strcmp(argv[1], "start") == 0)
            {
                return MyTunetSvcStart();
            }
            if(strcmp(argv[1], "stop") == 0)
            {
                return MyTunetSvcStop();
            }
            if(strcmp(argv[1], "login") == 0)
            {
                return MyTunetSvcLogin();
            }
            if(strcmp(argv[1], "logout") == 0)
            {
                return MyTunetSvcLogout();
            }


            if(strcmp(argv[1], "set") == 0)
            {
                if(argc != 8)
                {
                    puts(" Wrong usage !");
                    return ERR;
                }

                adapter = ethcards[atoi(argv[2])].name;
                username = argv[3];
                password = argv[4];
                usedot1x = atoi(argv[5]);

                switch(tolower(argv[6][0]))
                {
                    case 'e':
                        language = 0;
                        break;
                    case 'c':
                        language = 1;
                        break;
                    default:
                        language = 0;
                        break;

                }

                switch(tolower(argv[7][0]))
                {
                    case 'c':
                        limitation = LIMITATION_CAMPUS;
                        break;
                    case 'd':
                        limitation = LIMITATION_DOMESTIC;
                        break;
                    case 'n':
                        limitation = LIMITATION_NONE;
                        break;
                    default:
                        limitation = LIMITATION_DOMESTIC;
                        break;
                }

                mytunetsvc_set_user_config(username, password, 0,
                                        adapter, limitation, language);
                mytunetsvc_set_user_config_dot1x(usedot1x, 0);

                return OK;
            }

            puts(" Wrong usage !");
        }

    }
    else
    {
        if (!StartServiceCtrlDispatcher(ste))
        {
        }
        else
        {
        }
    }

    mytunetsvc_cleanup();
    return 0;
}


VOID TransmitLog(LOG *log)
{

    BUFFER *buf = NULL;
    INT32 len;
    DWORD cbWritten = 0;

    HANDLE hSlot;

    if(log)
    {

        buf = buffer_clear(buf);

        len = strlen(log->tag);
        buf = buffer_append(buf, (BYTE *)&len, sizeof(len));
        buf = buffer_append(buf, (BYTE *)log->tag, len);

        if(log->str)
        {
            len = strlen(log->str);
            buf = buffer_append(buf, (BYTE *)&len, sizeof(len));
            buf = buffer_append(buf, (BYTE *)log->str, len);
        }
        else
        {
            len = 0;
            buf = buffer_append(buf, (BYTE *)&len, sizeof(len));
        }

        len = log->datalen;
        if(len)
        {
            buf = buffer_append(buf, (BYTE *)&len, sizeof(len));
            buf = buffer_append(buf, (BYTE *)log->data, len);
        }
        else
        {
            buf = buffer_append(buf, (BYTE *)&len, sizeof(len));
        }

        hSlot = CreateFile(MYTUNET_LOGS_MAILSLOT_NAME,
                        GENERIC_WRITE, FILE_SHARE_READ,
                        (LPSECURITY_ATTRIBUTES) NULL,
                        OPEN_EXISTING,
                        FILE_ATTRIBUTE_NORMAL,
                        (HANDLE) NULL);

        if(hSlot != INVALID_HANDLE_VALUE)
        {
            WriteFile(  hSlot,
                        buf->data,
                        buf->len,
                        &cbWritten,
                        NULL);

            CloseHandle(hSlot);
        }

    }

    buf = buffer_free(buf);
}





void SetTheServiceStatus(DWORD dwCurrentState, DWORD dwWin32ExitCode,
                         DWORD dwCheckPoint,   DWORD dwWaitHint)
{
    SERVICE_STATUS ss;  // Current status of the service.

    // Disable control requests until the service is started.
    if (dwCurrentState == SERVICE_START_PENDING)
        ss.dwControlsAccepted = 0;
    else
        ss.dwControlsAccepted = SERVICE_ACCEPT_STOP|SERVICE_ACCEPT_SHUTDOWN;
    // Other flags include SERVICE_ACCEPT_PAUSE_CONTINUE
    // and SERVICE_ACCEPT_SHUTDOWN.

    // Initialize ss structure.
    ss.dwServiceType             = SERVICE_WIN32_OWN_PROCESS;
    ss.dwServiceSpecificExitCode = 0;
    ss.dwCurrentState            = dwCurrentState;
    ss.dwWin32ExitCode           = dwWin32ExitCode;
    ss.dwCheckPoint              = dwCheckPoint;
    ss.dwWaitHint                = dwWaitHint;

    // Send status of the service to the Service Controller.
    if (!SetServiceStatus(g_ServiceStatus, &ss))
        ErrorStopService(TEXT("SetServiceStatus"));
}

//  Handle API errors or other problems by ending the service and
//  displaying an error message to the debugger.

void ErrorStopService(LPTSTR lpszAPI)
{

    mytunetsvc_set_stop_flag();

    // Wait for the threads to stop.

    //............
    // Stop the service.
    SetTheServiceStatus(SERVICE_STOPPED, GetLastError(), 0, 0);
}


void WINAPI ServiceCtrl(DWORD dwCtrlCode)
{
    DWORD dwState = SERVICE_RUNNING;

    switch(dwCtrlCode)
    {
        case SERVICE_CONTROL_STOP:
            dwState = SERVICE_STOP_PENDING;
            break;

        case SERVICE_CONTROL_SHUTDOWN:
            dwState = SERVICE_STOP_PENDING;
            break;

        case SERVICE_CONTROL_INTERROGATE:
            break;

        case MYTUNET_SERVICE_LOGIN:
            mytunetsvc_get_user_config(&g_UserConfig);
            mytunetsvc_login();
            break;

        case MYTUNET_SERVICE_LOGOUT:
            mytunetsvc_logout();
            break;

        default:
            break;
    }

    // Set the status of the service.
    SetTheServiceStatus(dwState, NO_ERROR, 0, 0);

    // Tell ServiceMain thread to stop.
    if ((dwCtrlCode == SERVICE_CONTROL_STOP) ||
        (dwCtrlCode == SERVICE_CONTROL_SHUTDOWN))
    {
        mytunetsvc_set_stop_flag();
    }
}




// Called by the service control manager after the call to
// StartServiceCtrlDispatcher.


void WINAPI ServiceMain(DWORD dwArgc, LPTSTR *lpszArgv)
{

	mytunetsvc_clear_stop_flag();

    g_ServiceStatus = RegisterServiceCtrlHandler(MYTUNET_SERVICE_NAME, (LPHANDLER_FUNCTION)ServiceCtrl);
    SetTheServiceStatus(SERVICE_RUNNING, 0, 0, 0);

    mytunetsvc_get_user_config(&g_UserConfig);
    mytunetsvc_main();

    // Stop the service.
    SetTheServiceStatus(SERVICE_STOPPED, NO_ERROR, 0, 0);
}


