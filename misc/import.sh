#! /bin/bash -e
./import.pl -m > import.notr.dot
./import.pl -p > import-pkg.notr.dot
./import.pl -m -c > import-clu.notr.dot
make import.ps
make import-pkg.ps
make import-clu.ps
