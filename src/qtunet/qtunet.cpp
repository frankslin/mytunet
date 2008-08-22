#include <qthread.h>

#include  "qtunet.h"
#include "../ethcard.h"
#include "../mytunetsvc.h"
#include "../setting.h"
#include "../logs.h"
#include "../dot1x.h"
#include "../tunet.h"

QTunet::QTunet()
{
    mytunetsvc_set_config_file(NULL);
    mytunetsvc_set_transmit_log_func(MYTUNETSVC_TRANSMIT_LOG_QT);
    loadConfig();
}

QString QTunet::getUsername()
{
    return QString(userConfig.szUsername);
}

void QTunet::setUsername(QString v)
{
    const char *s = (const char *)v;
    if(strlen(s) > sizeof(userConfig.szUsername) - 1)
        return;

    //strcpy(userConfig.szUsername, s);
    userconfig_set_username(&userConfig, (char *)s);
}

bool QTunet::getUseDot1x()
{
    return userConfig.bUseDot1x;
}
void QTunet::setDot1x(bool use, bool retry)
{
    userconfig_set_dot1x(&userConfig, use, retry);
}

QString QTunet::getPassword()
{

    return QString(userConfig.szPassword);
}


QString QTunet::getMD5Password()
{

    return QString(userConfig.szMD5Password);
}

void QTunet::setPassword(QString pwd, bool isMD5)
{

    const char *s = (const char *)pwd;

    if(isMD5)
        userconfig_set_password_by_md5(&userConfig, (char *)s);
    else
        userconfig_set_password(&userConfig, (char *)s);

    //printf("%s", userConfig.szPassword);

}

int QTunet::getLimitation()
{
    return userConfig.limitation;
}
void QTunet::setLimitation(int v)
{
    userconfig_set_limitation(&userConfig, v);
}

QStringList QTunet::getEthcards()
{
    ETHCARD_INFO ethcards[20];
    QStringList l;

    int n = get_ethcards(ethcards, sizeof(ethcards));
    for(int i=0;i<n; i++)
    {
        l.push_back(ethcards[i].name);
    }
    return l;
}

ETHCARD_INFO QTunet::getEthcardInfo(QString name)
{
    ETHCARD_INFO ethcards[20];

    int n = get_ethcards(ethcards, sizeof(ethcards));
    int i;
    for(i=0;i<n; i++)
    {
        if(name == ethcards[i].name)
            break;
    }
    return ethcards[i];
}

QString QTunet::getEthcard()
{
    return QString(userConfig.szAdaptor);
}

void QTunet::setEthcard(QString name)
{

    const char *s = (const char *)name;
    if(strlen(s) > sizeof(userConfig.szAdaptor) - 1)
        return;

    userconfig_set_adapter(&userConfig, (char *)s);
}


void QTunet::saveConfig(bool bSavePassword)
{
    mytunetsvc_set_user_config_dot1x(userConfig.bUseDot1x, 0);
    isSavePassword = bSavePassword;

    if(bSavePassword)
    {
        mytunetsvc_set_user_config(userConfig.szUsername, userConfig.szMD5Password, true, userConfig.szAdaptor, userConfig.limitation, 0);
    }
    else
    {
        mytunetsvc_set_user_config(userConfig.szUsername, "", true, userConfig.szAdaptor, userConfig.limitation, 0);
    }

    setting_write_int(NULL, "savepassword", isSavePassword);
}


void QTunet::loadConfig()
{
    mytunetsvc_get_user_config(&userConfig);
    isSavePassword = setting_read_int(NULL, "savepassword", 0);
}

void QTunetThread::run()
{
    mytunetsvc_main();

}


void QTunet::login()
{
    puts("Login...");
    mytunetsvc_clear_stop_flag();
    mytunetsvc_set_global_config_from(&userConfig);
    g_qtunet_thread.start();
}

void QTunet::logout()
{
    puts("Logout...");
    mytunetsvc_set_stop_flag();
    if(!g_qtunet_thread.wait(3000))
    {
        tunet_reset();
        dot1x_reset();
        g_qtunet_thread.wait();
    }
    puts("Logout, OK!");
}


extern "C"
{
    VOID mytunetsvc_transmit_log_qt(LOG *log)
    {
        //printf("qt: %s ", log->tag);
        g_qtunetlogs.addLog(log);

    }
}

