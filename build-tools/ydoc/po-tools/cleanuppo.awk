#!/bin/awk -f
BEGIN{
  found=0;
  if (sles == 8) {
    linux = "SLES";
    suse = "SuSE";
  } else if (sles && sles < 8) {
    exit;
  } else if (sles && sles > 8) {
    exit;
  } else {
    linux = "UnitedLinux";
    suse="UnitedLinux";
    suseconfig="ULconfig";
  }
}

function sl2ul(l) {
  # mask dangerous strings
  gsub(/SuSE Linux AG/,"ESuS Linux AG",l);
  gsub(/SuSE Firewall/,"ESuS Firewall",l);
  # do the work
  # gsub(/SuSEconfig/,suseconfig,l);
  gsub(/SuSE[ -]?Linux/,linux,l);
  # pt_BR:
  gsub(/Linux SuSE/,linux,l);
  # the rest
  gsub(/SuSE\>/,suse,l);
  # put back masked strings
  gsub(/ESuS Linux AG/,"SuSE Linux AG",l);
  gsub(/ESuS Firewall/,"SuSE Firewall",l);
  print l;
}

/^#~/ {next}
/^#\./ {next}
/^msgid/ {found=0; print; next}
/^msgstr/ {found=1; sl2ul($0); next}

{
  if (found == 1) sl2ul($0)
  else print;
}

# eof
