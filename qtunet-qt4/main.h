
#include <QApplication>
#include <QComboBox>
#include <QCheckBox>
#include <QLineEdit>
//Added by qt3to4:
#include <QContextMenuEvent>
#include <QCloseEvent>
#include <QTimerEvent>
#include <QMouseEvent>
#include <QTextCodec>
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
#include <iostream>
using namespace std;


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
	Q_OBJECT

public:
	QTunetSystemTray(QWidget *mainWidget)
	{
		this->mainWidget = mainWidget;
        popupMenu.addAction(tr("&Quit MyTunet"), mainWidget, SLOT(mnuPopupQuit_clicked()));
		setContextMenu(&popupMenu);
		connect(this, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
				this, SLOT(activated(QSystemTrayIcon::ActivationReason)));
	}
    virtual void contextMenuEvent ( QContextMenuEvent * e )
    {
        popupMenu.popup(e->globalPos());
    }

private slots:
	void activated( QSystemTrayIcon::ActivationReason reason )
	{
		switch (reason)
		{
			case QSystemTrayIcon::DoubleClick:
			case QSystemTrayIcon::Trigger:
			case QSystemTrayIcon::MiddleClick:
				mainWidget->setVisible(!mainWidget->isVisible());
				break;
			default:
				break;
		}
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
		bool needHide;
        QTunetSystemTray tray;
		DlgAbout about;
        QString accountMoney, usedMoney;

    public:
        QTunetDlgMain() : Ui::DlgMain(), tray(this)
        {
			setupUi(this);
            startTimer(100);
			QIcon icon = QIcon(*(imgStatus->pixmap()));
			tray.setIcon(icon);
            tray.show();
			QTextCodec::setCodecForCStrings(QTextCodec::codecForName("gbk"));

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
                if(cmbAdapter->itemText(i) == g_qtunet.getEthcard())
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
			chkAutoLogin->setChecked(g_qtunet.autoLogin);

            cmbLimitation->insertItem(0,tr("None(International)"));
            cmbLimitation->insertItem(0,tr("Domestic"));
            cmbLimitation->insertItem(0,tr("Campus"));
            cmbLanguage->insertItem(0, tr("Chinese"));
            cmbLanguage->insertItem(0, tr("English"));
            chkSavePassword->setChecked(g_qtunet.isSavePassword);

            switch(g_qtunet.getLimitation())
            {
                case LIMITATION_CAMPUS:
                    cmbLimitation->setCurrentIndex(0);
                    break;
                case LIMITATION_NONE:
                    cmbLimitation->setCurrentIndex(2);
                    break;
                case LIMITATION_DOMESTIC:
                default:
                    cmbLimitation->setCurrentIndex(1);
                    break;
            }
            switch(g_qtunet.getLanguage())
            {
                case LANGUAGE_ENGLISH:
                    cmbLanguage->setCurrentIndex(0);    
                    break;
                case LANGUAGE_CHINESE:
                default:
                    cmbLanguage->setCurrentIndex(1);
                    break;
            }
			if (g_qtunet.autoLogin)
				cmdLogin_clicked();
        }


	private slots:
        void cmdLogin_clicked()
        {

            if(g_qtunet_thread.isRunning())
                return;

			needHide = true;
            g_qtunet.setUsername(txtUsername->text());
            g_qtunet.setEthcard(cmbAdapter->currentText());

            txtLog->append(tr("[CONFIG] Username: ") + txtUsername->text());
            txtLog->append(tr("[CONFIG] Ethcard : ") + cmbAdapter->currentText());

            ETHCARD_INFO ei = g_qtunet.getEthcardInfo(cmbAdapter->currentText());
            txtLog->append(QString(tr("[CONFIG] Ethcard MAC: ")) + QString(ei.mac));
            txtLog->append(QString(tr("[CONFIG] Ethcard IP : ")) + QString(ei.ip));
            switch(cmbLimitation->currentIndex())
            {
                case 0:
                    g_qtunet.setLimitation(LIMITATION_CAMPUS);
                    txtLog->append(tr("[CONFIG] Limitation: Campus"));
                    break;
                case 1:
                    g_qtunet.setLimitation(LIMITATION_DOMESTIC);
                    txtLog->append(tr("[CONFIG] Limitation: Domestic"));
                    break;
                case 2:
                    g_qtunet.setLimitation(LIMITATION_NONE);
                    txtLog->append(tr("[CONFIG] Limitation: None(International)"));
                    break;
            }
            switch(cmbLanguage->currentIndex())
            {
                case 0:
                    g_qtunet.setLanguage(LANGUAGE_ENGLISH);
                    break;
                case 1:
                    g_qtunet.setLanguage(LANGUAGE_CHINESE);
                    break;
            }
            g_qtunet.setDot1x(chkUseDot1x->isChecked(), false);
            txtLog->append(QString(tr("[CONFIG] Use 802.1x : ")) + (chkUseDot1x->isChecked() ? tr("Yes") : tr("No")));

            isUserEditingPassword = false;
            txtPassword->setText(g_qtunet.getMD5Password());
            isUserEditingPassword = true;


			g_qtunet.autoLogin = chkAutoLogin->isChecked();
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
            g_qtunet.setUsername(txtUsername->text());
            g_qtunet.setEthcard(cmbAdapter->currentText());
            switch(cmbLimitation->currentIndex())
            {
                case 0:
                    g_qtunet.setLimitation(LIMITATION_CAMPUS);
                    break;
                case 1:
                    g_qtunet.setLimitation(LIMITATION_DOMESTIC);
                    break;
                case 2:
                    g_qtunet.setLimitation(LIMITATION_NONE);
                    break;
            }

            g_qtunet.setDot1x(chkUseDot1x->isChecked(), false);
			g_qtunet.autoLogin = chkAutoLogin->isChecked();
            g_qtunet.saveConfig(chkSavePassword->isChecked());
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
				if (needHide)
				{
					hide();
					needHide = false;
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
				if (needHide)
				{
					hide();
					needHide = false;
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

//                if(qlog.tag != "MYTUNETSVC_LIMITATION" && qlog.tag != "MYTUNETSVC_STATE")
//                    printf("qtunet: %s %s %s\n", QS2CS(qlog.tag), QS2CS(qlog.data), QS2CS(qlog.str));

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
                    txtLog->append(tr("[802.1x] Starting..."));
                }

                if(qlog.tag == "DOT1X_START_FAIL")
                {
                    txtLog->append(tr("[802.1x] Start failed.\n" \
								"See console output for details."));
#ifdef _BSD
					txtLog->append(tr("Make sure that you have permission\n" \
								"to open bpf device."));
#endif
                }

                if(qlog.tag == "DOT1X_LOGON_REQUEST")
                {
                    txtLog->append(tr("[802.1x] Sending logon request ..."));
                }
                if(qlog.tag == "DOT1X_LOGON_SEND_USERNAME")
                {
                    txtLog->append(tr("[802.1x] Sending username..."));
                }
                if(qlog.tag == "DOT1X_LOGON_AUTH")
                {
                    txtLog->append(tr("[802.1x] Sending authentication data..."));
                }
                if(qlog.tag == "DOT1X_RESET")
                {
                    txtLog->append(tr("[802.1x] Reset!"));
                }
                if(qlog.tag == "DOT1X_STOP")
                {
                    txtLog->append(tr("[802.1x] Stopping ..."));
                }
                if(qlog.tag == "DOT1X_LOGOUT")
                {
                    txtLog->append(tr("[802.1x] Logout!"));
                }

                if(qlog.tag == "TUNET_START")
                {
                    txtLog->append(tr("[tunet]  Starting ..."));
                }
                if(qlog.tag == "TUNET_LOGON_SEND_TUNET_USER")
                {
                    txtLog->append(tr("[tunet]  Sending username ..."));
                }
                if(qlog.tag == "TUNET_LOGON_WELCOME")
                {
                    txtLog->append(tr("[tunet]  Welcome message : "));
                    txtLog->append(qlog.str);
                }
                if(qlog.tag == "TUNET_LOGON_MONEY")
                {
                    txtLog->append(tr("[tunet]  Tunet account : ") + qlog.str + tr(" yuan"));
                    lblStatus->setText(tr("Account : ") + qlog.str + tr(", Used money : 0.00"));
                }
                if(qlog.tag == "TUNET_LOGON_IPs")
                {
                    txtLog->append(tr("[tunet]  Logon IPs : ") + qlog.str);
                }

                if(qlog.tag == "TUNET_LOGON_SERVERTIME")
                {
                    txtLog->append(tr("[tunet]  Server time : ") + qlog.str);
                }
                if(qlog.tag == "TUNET_LOGON_LASTTIME")
                {
                    txtLog->append(tr("[tunet]  Last logon time : ") + qlog.str);
                }
                if(qlog.tag == "TUNET_LOGON_MSG")
                {
                    txtLog->append(tr("[tunet]  Logon Message : "));
                    txtLog->append(qlog.str);
                }
                if(qlog.tag == "TUNET_KEEPALIVE_MONEY")
                {
                    accountMoney = qlog.str;
                    lblStatus->setText(tr("Account : ") + accountMoney + tr(", Used money : ") + usedMoney);
                }
                if(qlog.tag == "TUNET_KEEPALIVE_USED_MONEY")
                {
                    usedMoney = qlog.str;
                    lblStatus->setText(tr("Account : ") + accountMoney + tr(", Used money : ") + usedMoney);
                }
                if(qlog.tag == "TUNET_NETWORK_ERROR")
                {
                    txtLog->append(tr("[tunet]  Network error : "));
					txtLog->append(qlog.str);
                }
                if(qlog.tag == "TUNET_ERROR")
                {
                    txtLog->append(tr("[tunet]  TUNET ERROR!"));
                    txtLog->append(qlog.str);
                }
                if(qlog.tag == "TUNET_KEEPALIVE_ERROR")
                {
                    txtLog->append(tr("[tunet]  Keepalive error : "));
					txtLog->append(qlog.str);
                }
                if(qlog.tag == "TUNET_STOP")
                {
                    txtLog->append(tr("[tunet]  Stopping ..."));
                }
                if(qlog.tag == "TUNET_LOGON_SEND_LOGOUT")
                {
                    txtLog->append(tr("[tunet]  Sending logout ..."));
                }
                if(qlog.tag == "TUNET_LOGOUT_MSG")
                {
                    txtLog->append(tr("[tunet]  Logout message : "));
                    txtLog->append(qlog.str);
                }
                if(qlog.tag == "TUNET_LOGOUT")
                {
                    txtLog->append(tr("[tunet]  Logout!"));
                }
				if(qlog.tag == "TUNET_LOGON_ERROR")
				{
					txtLog->append(tr("[tunet]  Logon error! message :"));
					txtLog->append(qlog.str);
//					puts(qlog.str.toLocal8Bit().data());
				}
                if(qlog.tag == "TUNET_THREAD_EXITING")
                {
//                    puts("Tunet Thread Exiting");
                }
            }

            if(isMinimized())
                hide();
        }

        void closeEvent ( QCloseEvent * e )
        {
            hide();
			e->ignore();
        }

};

