#include <QPushButton>
#include <QMessageBox>
#include <QTreeWidget>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QApplication>
#include <QStringList>
#include <QScrollBar>
#include <QString>
#include <QTextStream>
#include <QDialog>
#include <vector>
#include <QFileDialog>
#include <QLCDNumber>
#include <QLineEdit>
#include <QMenuBar>
#include <QCursor>
#include "cgui.h"

using namespace std;

MyWidget::MyWidget(QWidget *parent) : QWidget(parent){
	
	setWindowTitle("y2log - Analyzer");
	setMinimumSize(1024,800);
	setContextMenuPolicy(Qt::CustomContextMenu);

	//Menu-Bar

	connect(&hMenu, SIGNAL(aboutToShow()), SLOT(buildHMenu()));
	QMenuBar *menu = new QMenuBar();

	hMenu.setTitle("H&idden Types");
	
	fMenu = new QMenu();
	fMenu->setTitle("&File");
	fMenu->addAction("Open", this, SLOT(open()), QKeySequence(tr("Ctrl+O", "File|Open")));
	fMenu->addAction("Save", this, SLOT(saveEditor()), QKeySequence(tr("Ctrl+S", "File|Save")));
	fMenu->addSeparator();
	fMenu->addAction("Exit", qApp, SLOT(quit()));

	menu->addMenu(fMenu);
	menu->addMenu(&hMenu);
	menu->addAction("&Help", this, SLOT(help()));

	QPushButton *quit = new QPushButton("Quit");
	QPushButton *save = new QPushButton("Save");
	upDown = new QPushButton("Editor");
	upDown->setMaximumHeight(20);
	
	connect(quit, SIGNAL(clicked()), qApp, SLOT(quit()));
	connect(save, SIGNAL(clicked()), SLOT(saveEditor()));
	connect(upDown, SIGNAL(clicked()), SLOT(upDownEditor()));

	//TreeWidget for Entries
	
	listview = new QTreeWidget(this);
	QStringList headers;

	connect(listview, SIGNAL(itemDoubleClicked(QTreeWidgetItem*, int)), SLOT(highOne(QTreeWidgetItem*, int)));
	connect(listview, SIGNAL(itemExpanded(QTreeWidgetItem*)), SLOT(resizeColumns()));

	listview->setColumnCount(7);
	listview->setSelectionMode(QAbstractItemView::ExtendedSelection);
	listview->setAlternatingRowColors(true);
	listview->setMinimumHeight(400);

	headers << tr("host") << tr("date") << tr("time") << tr("loglevel");
	headers << tr("type") << tr("file") << tr("message");	

	listview->setHeaderLabels(headers);

	//TextEdit

	editor = new QTextEdit(this);
	editor->setLineWrapMode(QTextEdit::NoWrap);
	editor->hide();

	searchLine = new QLineEdit(this);
	QPushButton *searchButton = new QPushButton("Search", this);
	QPushButton *clearButton = new QPushButton("Clear", this);

	connect(searchButton, SIGNAL(clicked()), SLOT(search()));
	connect(clearButton, SIGNAL(clicked()), SLOT(clear()));
	connect(searchLine, SIGNAL(returnPressed()), SLOT(search()));

	//ComboBoxes for Search-Options

	cTypes = new QComboBox(this);
	cTypes->addItem("ALL");

	connect(cTypes, SIGNAL(activated(const QString&)), SLOT(cTypeChange(const QString&)));

	cLevel = new QComboBox(this);
	cLevel->addItem("ALL");
	cLevel->addItem("<0>");
	cLevel->addItem("<1>");
	cLevel->addItem("<2>");
	cLevel->addItem("<3>");
	cLevel->addItem("<4>");
	cLevel->addItem("<5>");
	cLevel->addItem("<6>");
	cLevel->addItem("<7>");

	cFunct = new QComboBox(this);
	cFunct->addItem("Hide");
	cFunct->addItem("Highlight");

	cColor = new QComboBox(this);
	cColor->addItem("red");
	cColor->addItem("yellow");
	cColor->addItem("green");

	QPushButton *OKButton = new QPushButton("OK", this);
	
	connect(OKButton, SIGNAL(clicked()), SLOT(selOptions()));
	
	from = new QLCDNumber(5, this);
	till = new QLCDNumber(5, this);
	
	from->display(0);
	till->display(0);

	scroll = new QScrollBar(Qt::Horizontal, this);
	scroll->setRange(0, 0);
	scroll->setMinimumWidth(500);

	connect(scroll, SIGNAL(valueChanged(int)), SLOT(scrollView(int)));

	//Defintion of Widget-Layout
	
	QHBoxLayout *hLayout = new QHBoxLayout();
	QHBoxLayout *hOptionLayout = new QHBoxLayout();
	QHBoxLayout *hScrollLayout = new QHBoxLayout();
	QVBoxLayout *layout = new QVBoxLayout();
	QHBoxLayout *hEndLayout = new QHBoxLayout();
	QVBoxLayout *vEditorLayout = new QVBoxLayout();
	QVBoxLayout *mainLayout = new QVBoxLayout();

	hLayout->addWidget(searchLine);
	hLayout->addWidget(searchButton);
	hLayout->addWidget(clearButton);

	hOptionLayout->addWidget(cTypes);
	hOptionLayout->addWidget(cLevel);
	hOptionLayout->addWidget(cFunct);
	hOptionLayout->addWidget(cColor);
	hOptionLayout->addWidget(OKButton);

	hScrollLayout->addWidget(from);
	hScrollLayout->addWidget(scroll);
	hScrollLayout->addWidget(till);

	layout->addLayout(hLayout);
	layout->addLayout(hOptionLayout);
	layout->addWidget(listview);
	layout->addLayout(hScrollLayout);

	hEndLayout->addWidget(save);
	hEndLayout->addWidget(quit);

	vEditorLayout->addWidget(editor);

	mainLayout->addLayout(layout);
	mainLayout->addWidget(upDown);
	mainLayout->addLayout(vEditorLayout);
	mainLayout->addLayout(hEndLayout);
	mainLayout->setMenuBar(menu);

	setLayout(mainLayout);

}

//Load LogFile in TreeWidget

void MyWidget::init(QString logName){
	setCursor(Qt::WaitCursor);
	listview->hide();
	log y2log;
	char *tlog = qstrdup(qPrintable(logName));

	logFile y2File(tlog, &y2log);
	y2File.readout();

	vector<string> keys;
	int temp;

	keys = y2log.getKeys();
	temp = keys.size();

	for (int i = 0; i < temp; i++){
		QTreeWidgetItem *tItem = new QTreeWidgetItem(listview);
		tItem->setText(0, (keys[i].c_str()));
		
		vector<entry> entries;
		entries = y2log.getEntries(keys[i]);
		int temp2 = entries.size();

		for (int y = 0; y < temp2; y++){
			QTreeWidgetItem *cItem = new QTreeWidgetItem(tItem);
			cItem->setText(0, (entries[y].getHost()).c_str());
			cItem->setText(1, (entries[y].getDate()).c_str());
			cItem->setText(2, (entries[y].getTime()).c_str());
			cItem->setText(3, (entries[y].getI()).c_str());
			cItem->setText(4, (entries[y].getType()).c_str());
			cItem->setText(5, (entries[y].getFile()).c_str());
			cItem->setText(6, (entries[y].getMsg()).c_str());

			if (types.contains((entries[y].getType()).c_str()) == false){
				types << (entries[y].getType()).c_str();
			}
		}
	}
	types.sort();
	cTypes->addItems(types);
	resizeColumns();
	listview->show();
	setCursor(Qt::ArrowCursor);
}

//Highlight double-clicked Item and its parent

void MyWidget::highOne(QTreeWidgetItem *item, int column){
	QString temp;

	item->setBackgroundColor(column, Qt::red);
	cItems.append(item);
	if (item->childCount() == 0){
		cItems.append(item->parent());
		item->parent()->setTextColor(0, Qt::darkRed);
	
		for (int i = 0; i < listview->columnCount(); i++){
			temp.append(item->text(i));
			temp.append(" ");
		}
		editor->append(temp);
	}
}

//Search through all columns (searchLine)

void MyWidget::search(){
	if (sItems.isEmpty() != true)
		sItems.clear();
	if(searchLine->text() == "")
		return;

	for(int i = 0; i < listview->columnCount(); i++){
		highlight(listview->findItems(searchLine->text(), Qt::MatchContains | Qt::MatchRecursive, i));
	}
}

// Highlight Item

void MyWidget::highlight(QList<QTreeWidgetItem*> items, QString col){
	cItems += items;
	//sItems += items;
	QColor color(col);
	for(int i = 0; i < items.count(); i++){
		items[i]->setBackgroundColor(0, color);
		if (items[i]->childCount() == 0){
			items[i]->parent()->setTextColor(0, color);
			cItems.append(items[i]->parent());
			if (sItems.contains(items[i]) == false)
				sItems.append(items[i]);
		}
	}
	till->display(sItems.count());
	scroll->setMaximum(sItems.count());
}

// Clear all colored Items

void MyWidget::clear(){
	for(int i = 0; i < cItems.count(); i++){
		cItems[i]->setTextColor(0, Qt::black);
		for(int y = 0; y < listview->columnCount(); y++)
			cItems[i]->setBackgroundColor(y, Qt::white);
	}
	cItems.clear();
	if(sItems.isEmpty() != true){
		sItems.clear();
	}
}

// Selection-Options

void MyWidget::selOptions(){
	if (sItems.isEmpty() != true)
		sItems.clear();
	if(cFunct->currentText() == "Highlight"){
		hideItems(cTypes->currentText(), cColor->currentText(), cLevel->currentText(), 0);
	}else if(cFunct->currentText() == "Hide"){
		hideItems(cTypes->currentText(), cColor->currentText(), cLevel->currentText(), 1);
	}else if(cFunct->currentText() == "Show"){
		hideItems(cTypes->currentText(), cColor->currentText(), cLevel->currentText(), 2);
	}
}

// Select all matching items

void MyWidget::hideItems(QString type, QString color, QString level, int opt){
	setCursor(Qt::WaitCursor);
	listview->hide();
	QList<QTreeWidgetItem*> items;

	if (type != "ALL"){
		items = listview->findItems(type, Qt::MatchExactly | Qt::MatchRecursive, 4); 
		
		if (level != "ALL"){
			for(int i = 0; i < items.count(); i++){
				if(items[i]->text(3) != level)
					items.takeAt(i);
			}
		}
	}else{
		if (level != "ALL")
			items = listview->findItems(level, Qt::MatchExactly | Qt::MatchRecursive, 3);
	}
	
	if (opt == 0){
		highlight(items, color);
	}else{
		for(int y = 0; y < items.count(); y++){
			if(opt == 1){
				listview->setItemHidden(items[y], true);
			}else{
				listview->setItemHidden(items[y], false);
			}
		}
	}
	if (opt == 1){
		hTypes.append(type);
	}
	if (opt == 2){
		hTypes.removeAll(type);
	}

	cTypeChange(cTypes->currentText());
	listview->show();
	setCursor(Qt::ArrowCursor);
}

// Show Qt-Open Dialog for log-File selection

void MyWidget::open(){
	QString fileName = QFileDialog::getOpenFileName(this, "Open y2log-File...", QDir::currentPath(), "y2log*");
	if (fileName != "")
		init(fileName);
}

// Scrolling through matching entries

void MyWidget::scrollView(int val){
	if (sItems.isEmpty() != true && val != 0){
		listview->setCurrentItem(sItems.at(val - 1));
		from->display(val);
	}
}

// Destructor FIXME

MyWidget::~MyWidget(){
	delete listview;
	delete searchLine;
	delete cTypes;
	delete cColor;
	delete cFunct;
	delete cLevel;
	delete from;
	delete till;
	delete scroll;
}

// Resize columns to contents

void MyWidget::resizeColumns(){
	for(int i = 0; i < listview->columnCount(); i++){
		listview->resizeColumnToContents(i);
	}
}

// Changing the Functions-ComboBox (cFunct)

void MyWidget::cTypeChange(const QString& type){
	if (hTypes.contains(type) == true){
		if (cFunct->findText("Show", Qt::MatchExactly) == -1)
			cFunct->addItem("Show");
		if (cFunct->findText("Hide", Qt::MatchExactly) != -1)
			cFunct->removeItem(cFunct->findText("Hide", Qt::MatchExactly));
	}else{
		if (cFunct->findText("Hide", Qt::MatchExactly) == -1){
			cFunct->addItem("Hide");
		}
		if (cFunct->findText("Show", Qt::MatchExactly) != -1)
			cFunct->removeItem(cFunct->findText("Show", Qt::MatchExactly));
	}
}

// Build MenuBar for hidden Types

void MyWidget::buildHMenu(){
	hMenu.clear();
	QAction *temp;
	for (int i = 0; i < hTypes.size(); i++){
		temp = hMenu.addAction(hTypes.at(i));
		connect(temp, SIGNAL(triggered()), SLOT(hMenuSel()));
	}
}

// Sets choosen Type to "unhidden"

void MyWidget::hMenuSel(){
	QAction *action = qobject_cast<QAction *>(sender());
	if (action)
		hideItems(action->text(), cColor->currentText(), cLevel->currentText(), 2);
}

// Opens Qt-FileDialog for saving Comment-File (Editor)

void MyWidget::saveEditor(){
	if(editor->toPlainText() == ""){
		QMessageBox::information(this, "Nothing to save!", "Comment-Box ist empty...", QMessageBox::Ok, QMessageBox::NoButton);
		return;
	}
	QString fileName = QFileDialog::getSaveFileName(this, "Save Comment-File", QDir::currentPath());
	if(fileName != ""){
		QFile sFile(fileName);
		
		sFile.open(QIODevice::WriteOnly);
		QTextStream out(&sFile);
		out << editor->toPlainText();
		sFile.close();
		if(sFile.exists() == false)
			QMessageBox::critical(this, "ERROR", "File could not be saved", QMessageBox::Ok, QMessageBox::NoButton);
	}
}

// Loads HelpFile in Help-Dialog

void MyWidget::help(){
	QDialog *helpDialog = new QDialog(this);
	helpDialog->setMinimumSize(450,100);
	QVBoxLayout *vLayout = new QVBoxLayout(helpDialog);

	QTextEdit *helpText = new QTextEdit(helpDialog);
	QPushButton *close = new QPushButton("Close", helpDialog);

	helpDialog->connect(close, SIGNAL(clicked()), SLOT(close()));

	vLayout->addWidget(helpText);
	vLayout->addWidget(close);
	helpDialog->setLayout(vLayout);

	QFile hFile("help");
	helpText->setReadOnly(true);
	if (hFile.open(QIODevice::ReadOnly) == false){
		QMessageBox::critical(this, "ERROR", "Help-File could not be found", QMessageBox::Ok, QMessageBox::NoButton);
	}else{
		QTextStream in(&hFile);
		helpText->append(in.readAll());
		helpDialog->show();
		helpDialog->raise();
		helpDialog->activateWindow();
	}
}

// Show and hide Editor-Widget

void MyWidget::upDownEditor(){
	if(editor->isHidden() == true){
		editor->show();
	}else{
		editor->hide();
	}
}
