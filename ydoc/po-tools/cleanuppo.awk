#!/bin/awk -f
BEGIN{found=0}

function sl2ul(l) {
  gsub(/SuSE[ -]?Linux/,"UnitedLinux",l);
  # pt_BR:
  gsub(/Linux SuSE/,"UnitedLinux",l);
  print l;
}

/^msgid/ {found=0; print; next}
/^msgstr/ {found=1; sl2ul($0); next}

{
  if (found == 1) sl2ul($0)
  else print;
}

# eof

