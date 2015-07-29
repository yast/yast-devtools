#! /bin/bash

LIST=`osc list openSUSE:Factory | grep -i -e yast2 -e skelcd -e "^libstorage$" -e perl-bootloader -e linuxrc`

for i in $LIST; do
  # compare if something is new by comparing binaries ( as version is part of rpm output )
  OS42=$(osc list -b openSUSE:42 $i -r standard -a x86_64)
  FACTORY=$(osc list -b openSUSE:Factory $i -r standard -a x86_64)
  if [ $OS42 == $FACTORY ]; then
     continue
  fi
  echo "submitting $i..."
  osc sr openSUSE:Factory $i openSUSE:42 -m "update of yast2"
done
