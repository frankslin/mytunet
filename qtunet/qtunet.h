#include <qobject.h>
#include <qstring.h>
#include <qstringlist.h>
#include <qmutex.h>
#include <qthread.h>
#include "../userconfig.h"
#include "../ethcard.h"
#include "../logs.h"
#include "../util.h"

class QTunetLogs : public QObject
{
public:
    class QTunetLog
    {
        public:
        QString tag, str, data;
        QTunetLog()
        {
        }
        QTunetLog(LOG *log) : tag(log->tag), str(log->str)
        {
            if(log->datalen != 0)
            {
                char *buf = new char[log->datalen * 3 + 3];
                buf2hex(log->data, log->datalen, buf);
                data = buf;
                delete []buf;
            }
        }

        QTunetLog(QTunetLog *log) : tag(log->tag), str(log->str), data(log->data)
        {
        }


    };

private :
    typedef QValueList<QTunetLog *> QTUNETLIST;
    QTUNETLIST logs;
    QMutex mutex;

public:
    void addLog(LOG *log)
    {
        mutex.lock();
        logs.push_back(new QTunetLog(log));
        mutex.unlock();
    }

    bool hasLog()
    {
        mutex.lock();
        bool r = !logs.empty();
        mutex.unlock();
        return r;
    }
    void fetchLog(QTunetLog &log)
    {
        mutex.lock();

        if(logs.empty())
        {
            log.tag = "";
        }
        else
        {
            log.tag = logs.first()->tag;
            log.str = logs.first()->str;
            log.data = logs.first()->data;

            delete logs.first();
            logs.remove(logs.begin());
        }
        mutex.unlock();
    }
};

class QTunet : public QObject
{
    Q_OBJECT
    private:
        USERCONFIG userConfig;

    public:
        bool       isSavePassword;

        QTunet();

        QString getUsername();
        void setUsername(QString v);

        bool getUseDot1x();
        void setDot1x(bool use, bool retry);

        QString getPassword();
        QString getMD5Password();
        void setPassword(QString pwd, bool isMD5 = false);

        int getLimitation();
        void setLimitation(int v);

        QStringList getEthcards();
        QString getEthcard();
        ETHCARD_INFO getEthcardInfo(QString name);
        void setEthcard(QString name);

        void saveConfig(bool bSavePassword = false);
        void loadConfig();


        void login();
        void logout();
    public slots:
        //void setValue( int v);
    signals:
        void statusChanged( int v);
};


class QTunetThread : public QThread
{
    virtual void run();
};

extern QTunet g_qtunet;
extern QTunetLogs g_qtunetlogs;
extern QTunetThread g_qtunet_thread;
