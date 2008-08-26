
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
#include "main.h"

QTunet g_qtunet;
QTunetLogs g_qtunetlogs;
QTunetThread g_qtunet_thread;

int main(int argc, char **argv)
{
    QApplication app(argc, argv);
    QTunetDlgMain dlg;

    mytunet_init();

    dlg.show();


    int r = app.exec();
    puts("Exiting...");
    mytunet_cleanup();
    return r;
}


