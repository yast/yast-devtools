/****************************************************************************
** Meta object code from reading C++ file 'cgui.h'
**
** Created: Tue Feb 20 10:48:02 2007
**      by: The Qt Meta Object Compiler version 59 (Qt 4.2.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "cgui.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'cgui.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 59
#error "This file was generated using the moc from 4.2.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

static const uint qt_meta_data_MyWidget[] = {

 // content:
       1,       // revision
       0,       // classname
       0,    0, // classinfo
      17,   10, // methods
       0,    0, // properties
       0,    0, // enums/sets

 // slots: signature, parameters, type, tag, flags
      12,   10,    9,    9, 0x0a,
      42,    9,    9,    9, 0x0a,
      51,    9,    9,    9, 0x0a,
      59,    9,    9,    9, 0x0a,
      72,    9,    9,    9, 0x0a,
      79,    9,    9,    9, 0x0a,
      95,    9,    9,    9, 0x0a,
     111,    9,    9,    9, 0x0a,
     132,    9,    9,    9, 0x0a,
     145,    9,    9,    9, 0x0a,
     156,    9,    9,    9, 0x0a,
     169,    9,    9,    9, 0x0a,
     176,    9,    9,    9, 0x0a,
     191,    9,    9,    9, 0x0a,
     205,    9,    9,    9, 0x0a,
     217,    9,    9,    9, 0x0a,
     237,    9,    9,    9, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_MyWidget[] = {
    "MyWidget\0\0,\0highOne(QTreeWidgetItem*,int)\0search()\0clear()\0"
    "selOptions()\0open()\0scrollView(int)\0resizeColumns()\0"
    "cTypeChange(QString)\0buildHMenu()\0hMenuSel()\0saveEditor()\0help()\0"
    "upDownEditor()\0saveConfigs()\0writeConf()\0showColHex(QString)\0"
    "colorDialog()\0"
};

const QMetaObject MyWidget::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_MyWidget,
      qt_meta_data_MyWidget, 0 }
};

const QMetaObject *MyWidget::metaObject() const
{
    return &staticMetaObject;
}

void *MyWidget::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_MyWidget))
	return static_cast<void*>(const_cast<MyWidget*>(this));
    return QWidget::qt_metacast(_clname);
}

int MyWidget::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: highOne((*reinterpret_cast< QTreeWidgetItem*(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 1: search(); break;
        case 2: clear(); break;
        case 3: selOptions(); break;
        case 4: open(); break;
        case 5: scrollView((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 6: resizeColumns(); break;
        case 7: cTypeChange((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 8: buildHMenu(); break;
        case 9: hMenuSel(); break;
        case 10: saveEditor(); break;
        case 11: help(); break;
        case 12: upDownEditor(); break;
        case 13: saveConfigs(); break;
        case 14: writeConf(); break;
        case 15: showColHex((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 16: colorDialog(); break;
        }
        _id -= 17;
    }
    return _id;
}
