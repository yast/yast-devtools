#include <cstring>
#include <iostream>
#include <fstream>
#include "cy2log.h"

using std::ifstream;
using std::string;

entry::entry(string nType, string nDate, string nTime, string nI, string nHost, string nFile, string nMsg){
	type = nType;
	date =  nDate;
	time =  nTime;
	i = nI;
	host =  nHost;
	file =  nFile;
	msg = nMsg;
}

entry::~entry(){
}

void entry::setItem(QTreeWidgetItem *nItem){
		item = nItem;
}

QTreeWidgetItem* entry::getItem(){
		return item;
}

string entry::getType(){
		return type;
}

string entry::getDate(){
		return date;
}

string entry::getTime(){
		return time;
}

string entry::getI(){
		return i;
}

string entry::getHost(){
		return host;
}

string entry::getFile(){
		return file;
}

string entry::getMsg(){
		return msg;
}

log::log(){
}

log::~log(){
}

int log::length(){
	int size = 0;
	
	map<string, vector<entry> >::iterator theIterator;
	for( theIterator = matrix.begin(); theIterator != matrix.end(); theIterator++ ) {
		size = size + theIterator->second.size();
	}	
	return size;
}

void log::append(entry item){	
	string key = item.getHost();
	if (matrix.find(key) == matrix.end()){
		vector<entry> temp;
		matrix[key] = temp;
	}
	matrix[key].push_back(item);
}	

vector<entry> log::getEntries(string key){
	return matrix[key];
}

vector<string> log::getKeys(){
	vector<string> temp;

	map<string, vector<entry> >::iterator theIterator;
	for( theIterator = matrix.begin(); theIterator != matrix.end(); theIterator++ )
	{
			temp.push_back(theIterator->first);
	}

	return temp;
}

logFile::logFile(char* nFile, log* ny2log){
	if (nFile != NULL){
		file = new char[strlen(nFile) + 1];
		strcpy(file, nFile);
	}else{
		file = NULL;
	}
	y2log = ny2log;
}

int logFile::readout(){
	ifstream f;
	string line;
	vector<string> words;
	char sep[2] = " ";
	vector<string> temp;
	
	f.open(file, ios::in);
	
	//readout of the logfile and parse all the words in a vector
	
	while (!f.eof()){
		getline(f, line);
		string::size_type a = 0, e;
    	while ( (a = line.find_first_not_of( sep, a)) != string::npos) {
	    	e = line.find_first_of( sep, a);
	        if (e != string::npos) {
				words.push_back( line.substr( a, e-a));
				a = e +1;
			}else{
				string tString;
				tString = line.substr(a) + "\n";
				words.push_back(tString);
				break;
			}
	    }		
	}
	cout << "File imported!" << endl;
	f.close();

	//push the entries in the entry-class
	
	string tHost = "unkown";
	for (int i = 0; i < words.size(); i++){
			
		if (words[i][words[i].size() - 1] != '\n'){
			temp.push_back(words[i]);
		}else{
			words[i].erase(words[i].size() - 1);
			temp.push_back(words[i]);
			string type, date, time, level, host, file, msg, rest;
			if (temp[3] == "libstorage" || temp[3] == "Bootloader_API"){
				for (int y = 6; y < temp.size(); y++){
					rest = rest + temp[y] + " ";
				}
				
				if (temp.size() > 3)
					type = temp[3];
				if (temp.size() > 0)
					date = temp[0];
				if (temp.size() > 1)
					time = temp[1];
				if (temp.size() > 2){
					level = temp[2];
					host = tHost;
				}
				if (temp.size() > 5)
					file = temp[5];
			}else if (temp[0][0] != '2' || temp[0][1] != '0'){
				type = "unknown";
				date = "unknown";
				time = "unknown";
				level = "<0>";
				host = tHost;
				file = "unknown";
				for (int y = 0; y < temp.size(); y++){
					rest = rest + temp[y] + " ";
				}
			}else{
				for (int y = 6; y < temp.size(); y++){
					rest = rest + temp[y] + " ";
				}

				if (temp.size() > 0)
					date = temp[0];
				if (temp.size() > 4)
					type = temp[4];
				if (temp.size() >  1)
					time = temp[1];
				if (temp.size() > 2)
					level = temp[2];
				if (temp.size() > 3){
					host = temp[3];
					tHost = temp[3];
				}
				if (temp.size() > 5)
					file = temp[5];
				
			}
			if (rest.empty())
				rest = "nothing";
			
			entry tEntry(type, date, time, level, host, file, rest);
			y2log->append(tEntry);
			temp.clear();
		}
	}
	cout << "File parsed!" << endl;	
	return 0;
}

logFile::~logFile(){
}
