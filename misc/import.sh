#! /bin/bash
./import.pl > import-notr.dot
tred import-notr.dot > import.dot
make import.ps
