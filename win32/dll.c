#include "../ethcard.h"
#include "../dot1x.h"
#include "../tunet.h"
#include "../logs.h"
#include "../userconfig.h"
#include "../mytunet.h"

#include <windows.h>

typedef unsigned long ULONG;
typedef ULONG * ULONG_PTR;
#include <wincrypt.h>

#pragma comment(lib, "Crypt32.lib")


#pragma data_seg("Shared")
	int __dummy = 0;
#pragma data_seg()

#pragma comment(linker,"/Section:Shared,rws")

typedef LPVOID (FAR WINAPI *FARPROC0)();
typedef LPVOID (FAR WINAPI *FARPROC1)(LPVOID);
typedef LPVOID (FAR WINAPI *FARPROC2)(LPVOID , LPVOID);
typedef LPVOID (FAR WINAPI *FARPROC3)(LPVOID , LPVOID, LPVOID);
typedef LPVOID (FAR WINAPI *FARPROC4)(LPVOID , LPVOID, LPVOID, LPVOID);
typedef LPVOID (FAR WINAPI *FARPROC5)(LPVOID , LPVOID, LPVOID, LPVOID, LPVOID);
typedef LPVOID (FAR WINAPI *FARPROC6)(LPVOID , LPVOID, LPVOID, LPVOID, LPVOID, LPVOID);

typedef LPVOID ( *CPROC0)();
typedef LPVOID ( *CPROC1)(LPVOID);
typedef LPVOID ( *CPROC2)(LPVOID , LPVOID);
typedef LPVOID ( *CPROC3)(LPVOID , LPVOID, LPVOID);
typedef LPVOID ( *CPROC4)(LPVOID , LPVOID, LPVOID, LPVOID);
typedef LPVOID ( *CPROC5)(LPVOID , LPVOID, LPVOID, LPVOID, LPVOID);
typedef LPVOID ( *CPROC6)(LPVOID , LPVOID, LPVOID, LPVOID, LPVOID, LPVOID);

typedef struct _THREAD_AGENT_PARAM
{
	CPROC0 CProc0;

	CPROC1 CProc1;
	LPVOID CProc1Param1;
}THREAD_AGENT_PARAM;

USERCONFIG userconfig;
ETHCARD_INFO ethcards[MAX_ETHCARDS];

#define TUNET_MUTEX_NAME "Global\\#%!@_$_TUNET_MUTEX_$_@!%#"

BOOL WINAPI MyTunetIsWirelessSvcRunning()
{
	SC_HANDLE		schService = NULL;
	SC_HANDLE		schSCManager = NULL;
	SERVICE_STATUS ssStatus; 
	BOOL        bRunning = FALSE;
	int			iRet = OK;

	schSCManager = OpenSCManager( 
		NULL,                    // local machine 
		NULL,                    // ServicesActive database 
		SC_MANAGER_ALL_ACCESS);  // full access rights 

	if (schSCManager == NULL)
	{
		iRet = ERR;
		goto end;
	}

    schService = OpenService( 
        schSCManager,          // SCM database 
        "WZCSVC",          // service name
        SERVICE_ALL_ACCESS); 
 
    if (schService == NULL) 
    { 
        iRet = ERR;
		goto end;
    }


	if (!QueryServiceStatus( 
            schService,
            &ssStatus) )
    {
        iRet = ERR;
		goto end;
    }
 
	if(ssStatus.dwCurrentState == SERVICE_RUNNING) 
	{
		bRunning = TRUE;
	}


end:
	if(schService) CloseServiceHandle(schService); 
	if(schSCManager) CloseServiceHandle(schSCManager);

	return bRunning;
}


HANDLE WINAPI MyTunetCreateMutex()
{
	HANDLE h = CreateMutex(NULL, TRUE, TUNET_MUTEX_NAME);
	if(GetLastError() == ERROR_ALREADY_EXISTS)
	{
		CloseHandle(h);
		return NULL;
	}
	return h;
}


VOID WINAPI MyTunetSetUserConfigDot1x(BOOL bUseDot1x, BOOL bRetryDot1x)
{
	userconfig_set_dot1x(&userconfig, bUseDot1x, bRetryDot1x);
}

VOID WINAPI MyTunetSetUserConfig(CHAR *username, CHAR *password, BOOL isMD5Pwd, CHAR *adapter, INT limitation, INT language)
{
	userconfig_set_username(&userconfig, username);
	if(!isMD5Pwd)
		userconfig_set_password(&userconfig, password);
	else
		userconfig_set_password_by_md5(&userconfig, password);

	userconfig_set_adapter(&userconfig, adapter);
	userconfig_set_limitation(&userconfig, limitation);
	userconfig_set_language(&userconfig, language);
}


INT WINAPI MyTunetGetUserConfigLimitation()
{
	return userconfig.limitation;
}

VOID WINAPI Dot1xStart()
{
	dot1x_start(&userconfig);
}

VOID WINAPI Dot1xStop()
{
	dot1x_stop();
}

INT WINAPI Dot1xGetState()
{
	return dot1x_get_state();
}

VOID WINAPI Dot1xReset()
{
	dot1x_reset();
}

BOOL WINAPI Dot1xIsTimeout()
{
	return dot1x_is_timeout();
}

VOID WINAPI TunetStart()
{
	tunet_start(&userconfig);
}


BOOL WINAPI TunetIsKeepaliveTimeout()
{
	return tunet_is_keepalive_timeout();
}

VOID WINAPI TunetReset()
{
	tunet_reset();
}

DWORD WINAPI TunetStopAgentThread(LPVOID param)
{
	//THREAD_AGENT_PARAM *ap = (THREAD_AGENT_PARAM *)param;
	//if(ap->CProc0) (ap->CProc0)();
	//if(ap->CProc1) (ap->CProc1)(ap->CProc1Param1);
	tunet_stop();
	return 0;
}

VOID WINAPI TunetStop(INT timeout, FARPROC1 DoEvents, VOID *param)
{
	HANDLE hAgent;
	DWORD  Id;
	DWORD  code;
	static BOOL inProc = FALSE;

	TICK  *tick;

	if(inProc) return;

	inProc = TRUE;

	tick = os_tick_new(timeout, FALSE);

	hAgent = CreateThread(NULL, 0, TunetStopAgentThread, NULL, 0, &Id);
	while(timeout == 0 || (!os_tick_is_active(tick)) )
	{
		GetExitCodeThread(hAgent, &code);
		if(code != STILL_ACTIVE)
			break;

		if(DoEvents) DoEvents(param);

		Sleep(20);
	}
	CloseHandle(hAgent);
	tick = os_tick_free(tick);
	inProc = FALSE;
}

INT WINAPI TunetGetState()
{
	return tunet_get_state();
}

LOG * WINAPI MyTunetLogFetch()
{
	return logs_fetch(g_logs, 0);
}

VOID WINAPI MyTunetLogFree(LOG *log)
{
	log_free(log);
}


INT WINAPI MyTunetLog_GetStringLen(LOG *log)
{
	if(!log) return 0;
	if(!log->str) return 0;
	return strlen(log->str);
}

VOID WINAPI MyTunetLog_GetString(LOG *log, CHAR *s)
{
	if(!log) return;

	if(!log->str) 
		strcpy(s, "");
	else
		strcpy(s, log->str);
}


INT WINAPI MyTunetLog_GetDataLen(LOG *log)
{
	if(!log) return 0;
	return log->datalen;
}

VOID WINAPI MyTunetLog_GetData(LOG *log, BYTE *s)
{
	if(!log) return;
	if(log->datalen)
		memcpy(s, log->data, log->datalen);
}


VOID WINAPI MyTunetLog_GetTag(LOG *log, CHAR *s)
{
	if(!log) return;
	strcpy(s, log->tag);
}


VOID WINAPI GetEthcardInfo(INT n, ETHCARD_INFO *ethcard)
{
	if(n < MAX_ETHCARDS)
		memcpy(ethcard, &ethcards[n], sizeof(ETHCARD_INFO));
}

INT WINAPI GetEthcardCount()
{
	return get_ethcards(ethcards, sizeof(ethcards));
}

VOID WINAPI MyTunetDLL_Init()
{
	mytunet_init();
}

VOID WINAPI MyTunetDLL_Cleanup()
{
	mytunet_cleanup();
}


CRYPT_DATA_BLOB * WINAPI ProtectData(BYTE *data, INT datalen , CHAR *optpwd)
{
	CRYPT_DATA_BLOB blobIn;
	CRYPT_DATA_BLOB blobEntropy;

	CRYPT_DATA_BLOB *pIn, *pEntropy, *pOut;

	DWORD dwFlags = CRYPTPROTECT_AUDIT;
	
	blobIn.pbData = (BYTE *)data;
	blobIn.cbData = datalen;

	pIn = &blobIn;
	pOut = os_new(DATA_BLOB, 1);

	if(optpwd)
	{
		blobEntropy.pbData = optpwd;
		blobEntropy.cbData = strlen(optpwd);

		pEntropy = &blobEntropy;
	}
	else
	{
		pEntropy = NULL;
	}

	if(CryptProtectData(
						pIn,
						L"MyTunet", 
						pEntropy,                         
						NULL,                         
						NULL,                    
						dwFlags,
						pOut))   
	{
		//dprintf("Protection is ready.\n");
	}

	return pOut;
}



CRYPT_DATA_BLOB * WINAPI UnprotectData(BYTE *data, INT datalen, CHAR *optpwd)
{
	CRYPT_DATA_BLOB blobIn;
	CRYPT_DATA_BLOB blobEntropy;

	LPWSTR desc;

	CRYPT_DATA_BLOB *pIn, *pEntropy, *pOut;

	DWORD dwFlags = CRYPTPROTECT_AUDIT;
	
	blobIn.pbData = (BYTE *)data;
	blobIn.cbData = datalen;

	pIn = &blobIn;
	pOut = os_new(DATA_BLOB, 1);

	if(optpwd)
	{
		blobEntropy.pbData = optpwd;
		blobEntropy.cbData = strlen(optpwd);

		pEntropy = &blobEntropy;
	}
	else
	{
		pEntropy = NULL;
	}

	if(CryptUnprotectData(
						pIn,
						&desc, 
						pEntropy,                         
						NULL,                         
						NULL,                    
						dwFlags,
						pOut))   
	{
		LocalFree(desc);
		//dprintf("Unprotection is ready.\n");
	}

	return pOut;
}


CRYPT_DATA_BLOB * WINAPI FreeDataBlob(CRYPT_DATA_BLOB *d)
{
	LocalFree(d->pbData);
	return (DATA_BLOB *)os_free(d);
}


INT WINAPI DataBlob_GetLen(CRYPT_DATA_BLOB *d)
{
	if(d && d->pbData) return d->cbData;
	return 0;
}

VOID WINAPI DataBlob_GetData(CRYPT_DATA_BLOB *d, BYTE *b)
{
	if(d && d->pbData) memcpy(b, d->pbData, d->cbData);
}


BOOL APIENTRY DllMain( HANDLE hModule, DWORD  dwReason, LPVOID lpReserved)
{
	switch(dwReason)
	{
		case DLL_PROCESS_ATTACH:
			MyTunetDLL_Init();
			break;
		case DLL_PROCESS_DETACH:
			MyTunetDLL_Cleanup();
			break;
	}
    return TRUE;
}


