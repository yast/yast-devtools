#! /bin/bash -e
MKDOT=../devtools/bin/ycpmakedep
$MKDOT -m > import.notr.dot
$MKDOT -p > import-pkg.notr.dot
$MKDOT -m -c > import-clu.notr.dot
make import.ps
make import-pkg.ps
make import-clu.ps
