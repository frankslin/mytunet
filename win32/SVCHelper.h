#ifndef __SVCHELPER_H__
#define __SVCHELPER_H__

#include "../os.h"
#include "../userconfig.h"

INT WINAPI MyTunetSvcInstall();
INT WINAPI MyTunetSvcRemove();
INT WINAPI MyTunetSvcStart();
INT WINAPI MyTunetSvcStop();
INT WINAPI MyTunetSvcLogin();
INT WINAPI MyTunetSvcLogout();

HANDLE WINAPI MyTunetSvcCreateLogsMailSlot();


#endif

