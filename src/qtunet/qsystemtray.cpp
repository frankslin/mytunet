//
// C++ Implementation: qsystemtray
//
// Description:
//
//
// Author: chice <wxiaoguang@gmail.com>, (C) 2005
//
// Copyright: See COPYING file that comes with this distribution
//
//

#include <qwidget.h>
#include <qlabel.h>
#include <qpixmap.h>
#include <qtooltip.h>
#include <qnamespace.h>
#include <Xlib.h>
#include "qsystemtray.h"

static void setTrayIcon(QWidget &widget)
{
    /* System Tray Protocol Specification. */

    Display *dpy = qt_xdisplay();

    Screen *screen = XDefaultScreenOfDisplay(dpy);
    int iScreen = XScreenNumberOfScreen(screen);
    char szAtom[32];
    snprintf(szAtom, sizeof(szAtom), "_NET_SYSTEM_TRAY_S%d", iScreen);
    Atom selectionAtom = XInternAtom(dpy, szAtom, False);
    XGrabServer(dpy);
    Window managerWin = XGetSelectionOwner(dpy, selectionAtom);
    if (managerWin != None)
        XSelectInput(dpy, managerWin, StructureNotifyMask);
    XUngrabServer(dpy);
    XFlush(dpy);
    if (managerWin != None) {
        XEvent ev;
        memset(&ev, 0, sizeof(ev));
        ev.xclient.type = ClientMessage;
        ev.xclient.window = managerWin;
        ev.xclient.message_type = XInternAtom(dpy, "_NET_SYSTEM_TRAY_OPCODE", False);
        ev.xclient.format = 32;
        ev.xclient.data.l[0] = CurrentTime;
        ev.xclient.data.l[1] = SYSTEM_TRAY_REQUEST_DOCK;
        ev.xclient.data.l[2] = widget.winId();
        ev.xclient.data.l[3] = 0;
        ev.xclient.data.l[4] = 0;
        XSendEvent(dpy, managerWin, False, NoEventMask, &ev);
        XSync(dpy, False);
    }
}

QSystemTray::QSystemTray(const QPixmap &icon) : QLabel(NULL, "", WMouseNoMask | WRepaintNoErase | WType_TopLevel | WStyle_Customize | WStyle_NoBorder | WStyle_StaysOnTop)
{

    setMinimumSize(22, 22);
    setBackgroundMode(X11ParentRelative);
    setBackgroundOrigin(WindowOrigin);

    setPixmap(icon);
    setAlignment(AlignHCenter);
    setScaledContents(true);
    setTrayIcon(*this);
}

void QSystemTray::setTooltipText(QString &text)
{
    QToolTip::remove(this);
    QToolTip::add(this, text);
}
