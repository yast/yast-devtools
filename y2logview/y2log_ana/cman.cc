#include <iostream>
#include <QApplication>
#include "cy2log.h"
#include "cgui.h"

using namespace std;


int main(int argc, char *argv[]){
	
	QApplication a(argc, argv);
	MyWidget widget;

	widget.show();

	return a.exec();
}
