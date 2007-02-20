#include <map>
#include <vector>

#ifndef CY2LOG_H
#define CY2LOG_H

using namespace std;

class entry{
		private:
			string type;
			string date;
			string time;
			string i;
			string host;
			string file;
			string msg;
		public:
			entry(string type, string date, string time, string i, string host, string file, string msg);
			~entry();
			string getType();
			string getDate();
			string getTime();
			string getI();
			string getHost();
			string getFile();
			string getMsg();
};

class log{
		private:
			map < string, vector<entry> > matrix;
		public:
				log();
				int length();
				~log();
				void append(entry);
				vector<entry> getEntries(string);
				vector<string> getKeys();
};

class logFile{
		private:
			char* file;
			log* y2log;
		public:
			logFile(char*, log*);
			~logFile();
			int readout();
};

#endif
