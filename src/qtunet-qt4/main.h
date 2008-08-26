
#include <qapplication.h>
#include <qcombobox.h>
#include <qcheckbox.h>
#include <qlineedit.h>
//Added by qt3to4:
#include <QContextMenuEvent>
#include <QCloseEvent>
#include <QTimerEvent>
#include <QMouseEvent>
#include <QObject>

#include "ui_dlg_main.h"
#include "ui_dlg_about.h"

#include <termios.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


#include "../ethcard.h"
#include "../mytunet.h"
#include "../tunet.h"
#include "../dot1x.h"
#include "../logs.h"
#include "../userconfig.h"

#include "qtunet.h"
#include <qimage.h>
#include <qpixmap.h>
#include <QSystemTrayIcon>
#include <QMenu>
class QTunetSystemTray : public QSystemTrayIcon
{
    QWidget *mainWidget;
    QMenu popupMenu;

public:
	QTunetSystemTray(QWidget *mainWidget)
	{
		this->mainWidget = mainWidget;
        popupMenu.addAction("Quit MyTunet", mainWidget, SLOT(mnuPopupQuit_clicked()));
		setContextMenu(&popupMenu);
	}
    virtual void contextMenuEvent ( QContextMenuEvent * e )
    {
        popupMenu.popup(e->globalPos());
    }


};


class DlgAbout: public QDialog, public Ui::DlgAbout
{

public:
	DlgAbout(QWidget *parent = 0) : QDialog(parent)
	{
		setupUi(this);
	}
};

#define QS2CS(s) (s.toLocal8Bit().data())
class QTunetDlgMain : public QDialog, public Ui::DlgMain
{
	Q_OBJECT

    private:
        bool isUserEditingPassword;
        QTunetSystemTray tray;
		DlgAbout about;
        QString accountMoney, usedMoney;

    public:
        QTunetDlgMain() : Ui::DlgMain(), tray(this)
        {
			setupUi(this);
            startTimer(100);
			QIcon icon = QIcon(*(imgStatus->pixmap()));
//			QIcon icon = windowIcon();
			tray.setIcon(icon);
            tray.show();
#ifdef FREEBSD
			tray.showMessage("info","FREEBSD");
#endif

            imgStatus_Busy->hide();
            imgStatus_Dot1x->hide();
            imgStatus_Domestic->hide();
            imgStatus_NoLimit->hide();
            imgStatus_None->hide();
            imgStatus_Campus->hide();

//          txtLog->setTextFormat( Qt::LogText );

            cmbAdapter->insertItems(0,g_qtunet.getEthcards());
            for(int i=0;i<cmbAdapter->count(); i++)
            {
                if(cmbAdapter->itemText(0) == g_qtunet.getEthcard())
                {
                    cmbAdapter->setCurrentIndex(i);
                    break;
                }
            }
            txtUsername->setText(g_qtunet.getUsername());

            isUserEditingPassword = false;
            if(g_qtunet.isSavePassword)
                txtPassword->setText(g_qtunet.getMD5Password());
            else
                txtPassword->setText("");
            isUserEditingPassword = true;

            chkUseDot1x->setChecked(g_qtunet.getUseDot1x());

            chkSavePassword->setChecked(g_qtunet.isSavePassword);

            cmbLimitation->insertItem(0,"Campus");
            cmbLimitation->insertItem(0,"Domestic");
            cmbLimitation->insertItem(0,"None(International)");
            chkSavePassword->setChecked(g_qtunet.isSavePassword);

            switch(g_qtunet.getLimitation())
            {
                case LIMITATION_CAMPUS:
                    cmbLimitation->setCurrentIndex(0);
                    break;
                case LIMITATION_DOMESTIC:
                    cmbLimitation->setCurrentIndex(1);
                    break;
                case LIMITATION_NONE:
                    cmbLimitation->setCurrentIndex(2);
                    break;
            }
        }


	private slots:
        void cmdLogin_clicked()
        {

            if(g_qtunet_thread.isRunning())
                return;


            g_qtunet.setUsername(txtUsername->text());
            g_qtunet.setEthcard(cmbAdapter->currentText());

            txtLog->append("[CONFIG] Username: " + txtUsername->text());
            txtLog->append("[CONFIG] Ethcard : " + cmbAdapter->currentText());

            ETHCARD_INFO ei = g_qtunet.getEthcardInfo(cmbAdapter->currentText());
            txtLog->append(QString("[CONFIG] Ethcard MAC: ") + QString(ei.mac));
            txtLog->append(QString("[CONFIG] Ethcard IP : ") + QString(ei.ip));
            switch(cmbLimitation->currentIndex())
            {
                case 0:
                    g_qtunet.setLimitation(LIMITATION_CAMPUS);
                    txtLog->append("[CONFIG] Limitation: Campus");
                    break;
                case 1:
                    g_qtunet.setLimitation(LIMITATION_DOMESTIC);
                    txtLog->append("[CONFIG] Limitation: Domestic");
                    break;
                case 2:
                    g_qtunet.setLimitation(LIMITATION_NONE);
                    txtLog->append("[CONFIG] Limitation: None(International)");
                    break;
            }

            g_qtunet.setDot1x(chkUseDot1x->isChecked(), false);
            txtLog->append(QString("[CONFIG] Use 802.1x : ") + (chkUseDot1x->isChecked() ? "Yes" : "No"));

            isUserEditingPassword = false;
            txtPassword->setText(g_qtunet.getMD5Password());
            isUserEditingPassword = true;


            g_qtunet.saveConfig(chkSavePassword->isChecked());

            g_qtunet.login();
        }
        void cmdLogout_clicked()
        {
            g_qtunet.logout();
        }
        void cmdQuit_clicked()
        {
            hide();
            g_qtunet.logout();
            QApplication::exit(0);
        }
        void txtPassword_returnPressed()
        {
            cmdLogin_clicked();
        }
        void txtPassword_textChanged( const QString & )
        {
            if(!isUserEditingPassword)
                return;
            g_qtunet.setPassword(QS2CS(txtPassword->text()));
        }

        void mnuPopupQuit_clicked()
        {
            cmdQuit_clicked();
        }

        void cmdHelp_clicked()
        {
            cmdAbout_clicked();
        }

        void cmdAbout_clicked()
        {
            about.show();
        }
    protected:
        void setStateIcon(const QPixmap &pixmap)
        {
            imgStatus->setPixmap(pixmap);
            tray.setIcon(pixmap);
        }

        void updateState(int dot1x_state, int tunet_state)
        {
            if(g_qtunet.getUseDot1x())
            {
                if(dot1x_state == DOT1X_STATE_NONE && tunet_state == TUNET_STATE_NONE)
                {
                    setStateIcon(*(imgStatus_None->pixmap()));
                    return;
                }
                if(dot1x_state != DOT1X_STATE_SUCCESS)
                {
                    setStateIcon(*(imgStatus_Dot1x->pixmap()));
                    return;
                }
                if(tunet_state != TUNET_STATE_KEEPALIVE)
                {
                    setStateIcon(*(imgStatus_Busy->pixmap()));
                    return;
                }
                switch(g_qtunet.getLimitation())
                {
                    case LIMITATION_CAMPUS:
                        setStateIcon(*(imgStatus_Campus->pixmap()));
                        break;
                    case LIMITATION_NONE:
                        setStateIcon(*(imgStatus_NoLimit->pixmap()));
                        break;
                    case LIMITATION_DOMESTIC:
                        setStateIcon(*(imgStatus_Domestic->pixmap()));
                        break;
                }
            }
            else
            {
                if(tunet_state == TUNET_STATE_NONE)
                {
                    setStateIcon(*(imgStatus_None->pixmap()));
                    return;
                }
                if(tunet_state != TUNET_STATE_KEEPALIVE)
                {
                    setStateIcon(*(imgStatus_Busy->pixmap()));
                    return;
                }
                switch(g_qtunet.getLimitation())
                {
                    case LIMITATION_CAMPUS:
                        setStateIcon(*(imgStatus_Campus->pixmap()));
                        break;
                    case LIMITATION_NONE:
                        setStateIcon(*(imgStatus_NoLimit->pixmap()));
                        break;
                    case LIMITATION_DOMESTIC:
                        setStateIcon(*(imgStatus_Domestic->pixmap()));
                        break;
                }
            }
        }

        void timerEvent( QTimerEvent * e)
        {
            static int tunet_limitation = LIMITATION_DOMESTIC;
            static int dot1x_state = DOT1X_STATE_NONE, tunet_state = TUNET_STATE_NONE;
            int len;


            while(g_qtunetlogs.hasLog())
            {
                QTunetLogs::QTunetLog qlog;

                g_qtunetlogs.fetchLog(qlog);

                if(qlog.tag != "MYTUNETSVC_LIMITATION" && qlog.tag != "MYTUNETSVC_STATE")
                    printf("qtunet: %s %s %s\n", QS2CS(qlog.tag), QS2CS(qlog.data), QS2CS(qlog.str));

                if(qlog.tag == "MYTUNETSVC_LIMITATION")
                {
                    BYTE buf[100];
                    hex2buf(QS2CS(qlog.data), buf, &len);
                    tunet_limitation = *((int *)buf);

                }
                if(qlog.tag == "MYTUNETSVC_STATE")
                {
                    BYTE buf[100];
                    hex2buf(QS2CS(qlog.data), buf, &len);
                    tunet_limitation = *((int *)buf);
                    dot1x_state = buf[0];
                    tunet_state = buf[1];

                    updateState(dot1x_state, tunet_state);
                }


                if(qlog.tag == "DOT1X_START")
                {
                    txtLog->append("[802.1x] Starting...");
                }

                if(qlog.tag == "DOT1X_START_FAIL")
                {
                    txtLog->append("[802.1x] Start failed.\n" \
								"See console output for details.");
#ifdef _BSD
					txtLog->append("Make sure that you have permission\n" \
								"to open bpf device.");
#endif
                }

                if(qlog.tag == "DOT1X_LOGON_REQUEST")
                {
                    txtLog->append("[802.1x] Sending logon request ...");
                }
                if(qlog.tag == "DOT1X_LOGON_SEND_USERNAME")
                {
                    txtLog->append("[802.1x] Sending username...");
                }
                if(qlog.tag == "DOT1X_LOGON_AUTH")
                {
                    txtLog->append("[802.1x] Sending authentication data...");
                }
                if(qlog.tag == "DOT1X_RESET")
                {
                    txtLog->append("[802.1x] Reset!");
                }
                if(qlog.tag == "DOT1X_STOP")
                {
                    txtLog->append("[802.1x] Stopping ...");
                }
                if(qlog.tag == "DOT1X_LOGOUT")
                {
                    txtLog->append("[802.1x] Logout!");
                }

                if(qlog.tag == "TUNET_START")
                {
                    txtLog->append("[tunet]  Starting ...");
                }
                if(qlog.tag == "TUNET_LOGON_SEND_TUNET_USER")
                {
                    txtLog->append("[tunet]  Sending username ...");
                }
                if(qlog.tag == "TUNET_LOGON_WELCOME")
                {
                    txtLog->append("[tunet]  Welcome message : ");
                    txtLog->append(qlog.str);
                }
                if(qlog.tag == "TUNET_LOGON_MONEY")
                {
                    txtLog->append("[tunet]  Tunet account : " + qlog.str + " yuan");
                    lblStatus->setText("Account : " + qlog.str + ", Used money : 0.00");
                }
                if(qlog.tag == "TUNET_LOGON_IPs")
                {
                    txtLog->append("[tunet]  Logon IPs : " + qlog.str);
                }

                if(qlog.tag == "TUNET_LOGON_SERVERTIME")
                {
                    txtLog->append("[tunet]  Server time : " + qlog.str);
                }
                if(qlog.tag == "TUNET_LOGON_LASTTIME")
                {
                    txtLog->append("[tunet]  Last logon time : " + qlog.str);
                }
                if(qlog.tag == "TUNET_LOGON_MSG")
                {
                    txtLog->append("[tunet]  Logon Message : ");
                    txtLog->append(qlog.str);
                }
                if(qlog.tag == "TUNET_KEEPALIVE_MONEY")
                {
                    accountMoney = qlog.str;
                    lblStatus->setText("Account : " + accountMoney + ", Used money : " + usedMoney);
                }
                if(qlog.tag == "TUNET_KEEPALIVE_USED_MONEY")
                {
                    usedMoney = qlog.str;
                    lblStatus->setText("Account : " + accountMoney + ", Used money : " + usedMoney);
                }
                if(qlog.tag == "TUNET_NETWORK_ERROR")
                {
                    txtLog->append("[tunet]  Network error : " + qlog.str);
                }
                if(qlog.tag == "TUNET_ERROR")
                {
                    txtLog->append("[tunet]  TUNET ERROR!");
                    txtLog->append(qlog.str);
                }
                if(qlog.tag == "TUNET_KEEPALIVE_ERROR")
                {
                    txtLog->append("[tunet]  Keepalive error : " + qlog.str);
                }
                if(qlog.tag == "TUNET_STOP")
                {
                    txtLog->append("[tunet]  Stopping ...");
                }
                if(qlog.tag == "TUNET_LOGON_SEND_LOGOUT")
                {
                    txtLog->append("[tunet]  Sending logout ...");
                }
                if(qlog.tag == "TUNET_LOGOUT_MSG")
                {
                    txtLog->append("[tunet]  Logout message : ");
                    txtLog->append(qlog.str);
                }
                if(qlog.tag == "TUNET_LOGOUT")
                {
                    txtLog->append("[tunet]  Logout!");
                }
            }

            if(isMinimized())
                hide();
        }

        void closeEvent ( QCloseEvent * e )
        {
            hide();
        }

};

