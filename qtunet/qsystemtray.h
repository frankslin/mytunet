//
// C++ Interface: qsystemtray
//
// Description:
//
//
// Author: chice <wxiaoguang@gmail.com>, (C) 2005
//
// Copyright: See COPYING file that comes with this distribution
//
//
#ifndef __QSYSTEMTRAY_H__
#define __QSYSTEMTRAY_H__

#define SYSTEM_TRAY_REQUEST_DOCK    0
#define SYSTEM_TRAY_BEGIN_MESSAGE   1
#define SYSTEM_TRAY_CANCEL_MESSAGE  2

#include <qlabel.h>
#include <qimage.h>
#include <qpixmap.h>

/*
virtual bool event ( QEvent * e )
virtual void mousePressEvent ( QMouseEvent * e )
virtual void mouseReleaseEvent ( QMouseEvent * e )
virtual void mouseDoubleClickEvent ( QMouseEvent * e )
*/
class QSystemTray : public QLabel
{
public:
    QSystemTray(const QPixmap &icon);
    void setTooltipText(QString &text);



    /*void mousePressEvent(self, e):
        if e.button() == qt.Qt.RightButton:
        self.emit(qt.PYSIGNAL("contextMenuRequested(const QPoint&)"), (e.globalPos(),))
        elif e.button() == qt.Qt.LeftButton:
        self.emit(qt.PYSIGNAL("activated()"), ())
    */
};

#endif//__QSYSTEMTRAY_H__
