#! /bin/bash

LIST=`osc list openSUSE:Factory | grep -i -e yast2 -e skelcd -e "^libstorage$" -e perl-bootloader -e linuxrc`

for i in $LIST; do
  # compare if something is new by comparing binaries ( as version is part of rpm output )
  OS42=$(osc cat openSUSE:42 $i $i.spec 2>/dev/null | grep "^Version" | sed 's/Version:[[:space:]]*//;s/#.*$//')
  FACTORY=$(osc cat openSUSE:Factory $i $i.spec 2>/dev/null | grep "^Version" | sed 's/Version:[[:space:]]*//;s/#.*$//')
  if [ "$OS42" == "$FACTORY" ]; then
     continue
  fi
  echo "submitting $i..."
  osc sr openSUSE:Factory $i openSUSE:42 -m "opensuse42_submit.sh: update of yast2 related package to the SLE12SP1 version"
done
