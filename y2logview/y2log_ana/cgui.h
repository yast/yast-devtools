#include <QWidget>
#include <QPushButton>
#include <QTreeWidgetItem>
#include <QTreeWidget>
#include <QComboBox>
#include <QTextEdit>
#include <QLCDNumber>
#include <QMenu>
#include "cy2log.h"

#ifndef CGUI_H
#define CGUI_H

class MyWidget : public QWidget{
		Q_OBJECT
	public:
		MyWidget(QWidget *parent = 0);
		~MyWidget();
		void highlight(QList<QTreeWidgetItem*>, QString color = "red");
		void highLine(QTreeWidgetItem*);
		void init(QString);
		void hideItems(QString, QString, QString, int);
		void loadConfigs();

	private:
		QTreeWidget *listview;
		QLineEdit *searchLine;
		QTextEdit *editor;
		QList<QTreeWidgetItem*> cItems;
		QList<QTreeWidgetItem*> sItems;
		QList<QString> hTypes;
		QStringList types;
		QPushButton *upDown;
		QComboBox *cTypes;
		QComboBox *cColor;
		QComboBox *cLevel;
		QComboBox *cFunct;
		QLCDNumber *from;
		QLCDNumber *till;
		QScrollBar *scroll;
		QMenu hMenu;
		QMenu *fMenu;
		map<QString, QColor> levelBg;

	public slots:
		void highOne(QTreeWidgetItem*, int);
		void search();
		void clear();
		void selOptions();
		void open();
		void scrollView(int);
		void resizeColumns();
		void cTypeChange(const QString&);
		void buildHMenu();
		void hMenuSel();
		void saveEditor();
		void help();
		void upDownEditor();
};

#endif
