#include <QWidget>
#include <QPushButton>
#include <QTreeWidgetItem>
#include <QTreeWidget>
#include <QComboBox>
#include <QTextEdit>
#include <QLCDNumber>
#include <QMenu>
#include <QLabel>
#include <QCheckBox>
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
		void buildConfig();

	private:
		QString configPath;
		QTreeWidget *listview;
		QLineEdit *searchLine;
		QLineEdit *hexCol;
		QTextEdit *editor;
		QList<QTreeWidgetItem*> cItems;
		QList<QTreeWidgetItem*> sItems;
		QList<QString> hTypes;
		QStringList types;
		QPushButton *upDown;
		QPushButton *colSave;
		QCheckBox *colApply;
		QComboBox *cTypes;
		QComboBox *cColor;
		QComboBox *cLevel;
		QComboBox *cFunct;
		QComboBox *level;
		QLCDNumber *from;
		QLCDNumber *till;
		QScrollBar *scroll;
		QLabel *colLabel;
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
		void saveConfigs();
		void writeConf();
		void showColHex(const QString&);
		void colorDialog();
		void searchAhead(QTreeWidgetItem*, int);
};

#endif
