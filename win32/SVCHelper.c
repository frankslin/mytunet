#include <windows.h>
#include <tchar.h>
#include "svchelper.h"
#include "../os.h"
#include "../des.h"
#include "../md5.h"
#include "../userconfig.h"
#include "../util.h"
#include "../setting.h"
#include "../logs.h"
#include "../mytunetsvc.h"




HANDLE WINAPI MyTunetSvcCreateLogsMailSlot()
{
    HANDLE hSlot = CreateMailslot(MYTUNET_LOGS_MAILSLOT_NAME, 
        0,                             // no maximum message size 
        0,						       // no waiting
        (LPSECURITY_ATTRIBUTES) NULL); // no security attributes 

	return hSlot;
}


LOG * WINAPI MyTunetSvcGetLogByMailSlot(HANDLE hSlot)
{
	BOOL fResult = FALSE;
	//HANDLE hSlot = INVALID_HANDLE_VALUE;  
	DWORD cbMessage = 0, cMessage = 0;
	DWORD cbRead = 0;

	
	BYTE *p = NULL, *bytebuf = NULL;
	DWORD len = 0;
	STRING *stag = NULL;
	STRING *sstr = NULL;
	BUFFER *bdata = NULL;
	LOG *log = NULL;

	CHAR *tag = NULL, *str = NULL;
	BYTE *data = NULL;
	INT datalen = 0;


	if(!hSlot) return NULL;

    fResult = GetMailslotInfo(hSlot,  // mailslot handle 
        (LPDWORD) NULL,               // no maximum message size 
        &cbMessage,                   // size of next message 
        &cMessage,                    // number of messages 
        (LPDWORD) NULL);              // no read time-out 

    if (!fResult) 
    { 
        goto end;
    } 
 
    if (cbMessage == MAILSLOT_NO_MESSAGE) 
    { 
        goto end;
    } 
 



	
	bytebuf = os_new(BYTE, cbMessage);

	if(!bytebuf)
	{
		goto end;
	}
	

    fResult = ReadFile(hSlot, 
        bytebuf, 
        cbMessage, 
        &cbRead, 
        NULL); 


    if (!fResult) 
    { 
        goto end;
    } 


	p = bytebuf;

	len = BUF_FETCH_DWORD(p);
	stag = string_nappend(stag, p, len);
	BUF_ROLL(p, len);
	tag = stag->str;

	len = BUF_FETCH_DWORD(p);
	if(len)
	{
		sstr = string_nappend(sstr, p, len);
		BUF_ROLL(p, len);

		str = sstr->str;
	}

	len = BUF_FETCH_DWORD(p);
	if(len)
	{
		datalen = len;
		bdata = buffer_append(bdata, p, len);
		BUF_ROLL(p, len);

		data = bdata->data;
	}

	log = log_new(tag, str, data, datalen);

end:
	stag = string_free(stag);
	sstr = string_free(sstr);
	bdata = buffer_free(bdata);

	bytebuf = os_free(bytebuf);

	return log;
}






DWORD StopService( SC_HANDLE hSCM, SC_HANDLE hService, BOOL fStopDependencies, DWORD dwTimeout ) 
{
   SERVICE_STATUS ss;
   DWORD dwStartTime = GetTickCount();

   // Make sure the service is not already stopped
   if ( !QueryServiceStatus( hService, &ss ) )
      return GetLastError();

   if ( ss.dwCurrentState == SERVICE_STOPPED ) 
      return ERROR_SUCCESS;

   // If a stop is pending, just wait for it
   while ( ss.dwCurrentState == SERVICE_STOP_PENDING ) 
   {
      Sleep( ss.dwWaitHint );
      if ( !QueryServiceStatus( hService, &ss ) )
         return GetLastError();

      if ( ss.dwCurrentState == SERVICE_STOPPED )
         return ERROR_SUCCESS;

      if ( GetTickCount() - dwStartTime > dwTimeout )
         return ERROR_TIMEOUT;
   }

   // If the service is running, dependencies must be stopped first
   if ( fStopDependencies ) 
   {
      DWORD i;
      DWORD dwBytesNeeded;
      DWORD dwCount;

      LPENUM_SERVICE_STATUS   lpDependencies = NULL;
      ENUM_SERVICE_STATUS     ess;
      SC_HANDLE               hDepService;

      // Pass a zero-length buffer to get the required buffer size
      if ( EnumDependentServices( hService, SERVICE_ACTIVE, 
         lpDependencies, 0, &dwBytesNeeded, &dwCount ) ) 
      {
         // If the Enum call succeeds, then there are no dependent
         // services so do nothing
      } 
      else 
      {
         if ( GetLastError() != ERROR_MORE_DATA )
            return GetLastError(); // Unexpected error

         // Allocate a buffer for the dependencies
         lpDependencies = (LPENUM_SERVICE_STATUS) HeapAlloc( 
               GetProcessHeap(), HEAP_ZERO_MEMORY, dwBytesNeeded );

         if ( !lpDependencies )
            return GetLastError();

         __try {
            // Enumerate the dependencies
            if ( !EnumDependentServices( hService, SERVICE_ACTIVE, 
                  lpDependencies, dwBytesNeeded, &dwBytesNeeded,
                  &dwCount ) )
               return GetLastError();

            for ( i = 0; i < dwCount; i++ ) 
            {
               ess = *(lpDependencies + i);

               // Open the service
               hDepService = OpenService( hSCM, ess.lpServiceName, 
                     SERVICE_STOP | SERVICE_QUERY_STATUS );
               if ( !hDepService )
                  return GetLastError();

               __try {
                   // Send a stop code
                  if ( !ControlService( hDepService, 
                           SERVICE_CONTROL_STOP,
                           &ss ) )
                     return GetLastError();

                  // Wait for the service to stop
                  while ( ss.dwCurrentState != SERVICE_STOPPED ) 
                  {
                      Sleep( ss.dwWaitHint );
                     if ( !QueryServiceStatus( hDepService, &ss ) )
                        return GetLastError();

                     if ( ss.dwCurrentState == SERVICE_STOPPED )
                        break;

                     if ( GetTickCount() - dwStartTime > dwTimeout )
                        return ERROR_TIMEOUT;
                  }

               } 
               __finally 
               {
                  // Always release the service handle
                  CloseServiceHandle( hDepService );

               }
            }

         } 
         __finally 
         {
            // Always free the enumeration buffer
            HeapFree( GetProcessHeap(), 0, lpDependencies );
         }
      } 
   }

   // Send a stop code to the main service
   if ( !ControlService( hService, SERVICE_CONTROL_STOP, &ss ) )
      return GetLastError();

   // Wait for the service to stop
   while ( ss.dwCurrentState != SERVICE_STOPPED ) 
   {
      Sleep( ss.dwWaitHint );
      if ( !QueryServiceStatus( hService, &ss ) )
         return GetLastError();

      if ( ss.dwCurrentState == SERVICE_STOPPED )
         break;

      if ( GetTickCount() - dwStartTime > dwTimeout )
         return ERROR_TIMEOUT;
   }

   // Return success
   return ERROR_SUCCESS;
}



INT WINAPI MyTunetSvcInstall(CHAR *szCmdLine)
{
	SC_HANDLE   schService = NULL;
	SC_HANDLE	schSCManager = NULL;
	SERVICE_DESCRIPTION desc;
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

    schService = CreateService( 
        schSCManager,              // SCManager database 
        MYTUNET_SERVICE_NAME,      // name of service 
        MYTUNET_SERVICE_NAME,	   // service name to display 
        SERVICE_ALL_ACCESS,        // desired access 
        SERVICE_WIN32_OWN_PROCESS, // service type 
        SERVICE_AUTO_START,      // start type 
        SERVICE_ERROR_NORMAL,      // error control type 
        szCmdLine,				   // service's binary 
        NULL,                      // no load ordering group 
        NULL,                      // no tag identifier 
        NULL,                      // no dependencies 
        NULL,                      // LocalSystem account 
        NULL);                     // no password 
 
	desc.lpDescription = MYTUNET_SERVICE_DESC;
	ChangeServiceConfig2(schService, SERVICE_CONFIG_DESCRIPTION, &desc);

    if (schService == NULL) 
	{
		iRet = ERR;
		goto end;
	}

end:
	if(schService) CloseServiceHandle(schService); 
	if(schSCManager) CloseServiceHandle(schSCManager);

	return iRet;
}


INT WINAPI MyTunetSvcRemove()
{
	SC_HANDLE   schService;
	SC_HANDLE	schSCManager;
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
        schSCManager,       // SCManager database 
        MYTUNET_SERVICE_NAME,       // name of service 
        DELETE);            // only need DELETE access 
 
    if (schService == NULL) 
	{
		iRet = ERR;
		goto end;
	}
 
    if (! DeleteService(schService) ) 
	{
		iRet = ERR;
		goto end;
	}

	
end:
	if(schService) CloseServiceHandle(schService); 
	if(schSCManager) CloseServiceHandle(schSCManager);

	return iRet;
}

INT WINAPI MyTunetSvcStart()
{
	SC_HANDLE   schService = NULL;
	SC_HANDLE	schSCManager = NULL;
	int			iRet = OK;

    SERVICE_STATUS ssStatus; 
    DWORD dwOldCheckPoint; 
    DWORD dwStartTickCount;
    DWORD dwWaitTime;
 
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
        MYTUNET_SERVICE_NAME,          // service name
        SERVICE_ALL_ACCESS); 
 
    if (schService == NULL) 
    { 
        iRet = ERR;
		goto end;
    }
 
    if (!StartService(schService, 0,NULL) )
    { 
        iRet = ERR;
		goto end;
    }

    // Check the status until the service is no longer start pending. 

    if (!QueryServiceStatus( 
            schService,
            &ssStatus) )
    {
        iRet = ERR;
		goto end;
    }
 
    // Save the tick count and initial checkpoint.

    dwStartTickCount = GetTickCount();
    dwOldCheckPoint = ssStatus.dwCheckPoint;

    while (ssStatus.dwCurrentState == SERVICE_START_PENDING) 
    { 
        // Do not wait longer than the wait hint. A good interval is 
        // one tenth the wait hint, but no less than 1 second and no 
        // more than 10 seconds. 
 
        dwWaitTime = ssStatus.dwWaitHint / 10;

        if( dwWaitTime < 1000 )
            dwWaitTime = 1000;
        else if ( dwWaitTime > 10000 )
            dwWaitTime = 10000;

        Sleep( dwWaitTime );

        // Check the status again. 
 
        if (!QueryServiceStatus( 
                schService,   // handle to service 
                &ssStatus) )  // address of structure
            break; 
 
        if ( ssStatus.dwCheckPoint > dwOldCheckPoint )
        {
            // The service is making progress.

            dwStartTickCount = GetTickCount();
            dwOldCheckPoint = ssStatus.dwCheckPoint;
        }
        else
        {
            if(GetTickCount()-dwStartTickCount > ssStatus.dwWaitHint || dwStartTickCount > GetTickCount())
            {
                // No progress made within the wait hint, or GetTickCount is reset.
                break;
            }
        }
    } 

    if (ssStatus.dwCurrentState != SERVICE_RUNNING) 
    {
		iRet = ERR;
		goto end;
    }

end:
	if(schService) CloseServiceHandle(schService); 
	if(schSCManager) CloseServiceHandle(schSCManager);

	return iRet;
}


INT WINAPI MyTunetSvcStop()
{
	SC_HANDLE   schService = NULL;
	SC_HANDLE	schSCManager = NULL;
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
        MYTUNET_SERVICE_NAME,          // service name
        SERVICE_ALL_ACCESS); 
 
    if (schService == NULL) 
    { 
        iRet = ERR;
		goto end;
    }

	if(StopService(schSCManager, schService, 0, 10000) != ERROR_SUCCESS)
    { 
        iRet = ERR;
		goto end;
    }


end:
	if(schService) CloseServiceHandle(schService); 
	if(schSCManager) CloseServiceHandle(schSCManager);

	return iRet;
}


INT WINAPI MyTunetSvcLogin()
{
	SC_HANDLE		schService = NULL;
	SC_HANDLE		schSCManager = NULL;
	SERVICE_STATUS	ss;

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
        MYTUNET_SERVICE_NAME,          // service name
        SERVICE_ALL_ACCESS
		); 
 
    if (schService == NULL) 
    { 
        iRet = ERR;
		goto end;
    }

	if(!ControlService(schService, MYTUNET_SERVICE_LOGIN, &ss))
    { 
        iRet = ERR;
		goto end;
    }


end:
	if(schService) CloseServiceHandle(schService); 
	if(schSCManager) CloseServiceHandle(schSCManager);

	return iRet;
}


INT WINAPI MyTunetSvcLogout()
{
	SC_HANDLE		schService = NULL;
	SC_HANDLE		schSCManager = NULL;
	SERVICE_STATUS	ss;
	
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
        MYTUNET_SERVICE_NAME,          // service name
        SERVICE_ALL_ACCESS
		); 
 
    if (schService == NULL) 
    { 
        iRet = ERR;
		goto end;
    }

	if(ControlService(schService, MYTUNET_SERVICE_LOGOUT, &ss) != ERROR_SUCCESS)
    { 
        iRet = ERR;
		goto end;
    }


end:
	if(schService) CloseServiceHandle(schService); 
	if(schSCManager) CloseServiceHandle(schSCManager);

	return iRet;
}


BOOL WINAPI MyTunetSvcIsInstalled()
{
	SC_HANDLE		schService = NULL;
	SC_HANDLE		schSCManager = NULL;
	
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
        MYTUNET_SERVICE_NAME,          // service name
        SERVICE_ALL_ACCESS); 
 
    if (schService == NULL) 
    { 
        iRet = ERR;
		goto end;
    }


end:
	if(schService) CloseServiceHandle(schService); 
	if(schSCManager) CloseServiceHandle(schSCManager);

	return (iRet == OK);
}

INT WINAPI MyTunetSvcGetState()
{
	SC_HANDLE   schService = NULL;
	SC_HANDLE	schSCManager = NULL;
	int			iRet = OK;
    SERVICE_STATUS ssStatus; 
 
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
        MYTUNET_SERVICE_NAME,          // service name
        SERVICE_ALL_ACCESS); 
 
    if (schService == NULL) 
    { 
        iRet = ERR;
		goto end;
    }

    // Check the status until the service is no longer start pending. 
    if (!QueryServiceStatus( 
            schService,
            &ssStatus) )
    {
        iRet = ERR;
		goto end;
    }

end:
	if(schService) CloseServiceHandle(schService); 
	if(schSCManager) CloseServiceHandle(schSCManager);

	if(iRet == OK)
		return ssStatus.dwCurrentState;
	else
		return -1;

}




INT WINAPI MyTunetSvcSetUserConfig(CHAR *username, CHAR *password, BOOL isMD5Pwd, CHAR *adapter, INT limitation, INT language)
{
	return mytunetsvc_set_user_config(username, password, isMD5Pwd, adapter, limitation, language );
}
INT WINAPI MyTunetSvcSetUserConfigDot1x(BOOL usedot1x, BOOL retrydot1x)
{
	return mytunetsvc_set_user_config_dot1x(usedot1x,  retrydot1x);
}
/*
INT WINAPI MyTunetSvcGetUserConfig(USERCONFIG *uc);

*/