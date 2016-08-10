#!/bin/sh
#
# Prepare a Travis node for running Yast build:
#
# - import YaST:Head:Travis OBS repository GPG key
# - add YaST:Head:Travis OBS repository
# - download/refresh repository metadata
# - optionally install specified packages
# - optionally install specified Ruby gems (from rubygems.org)
#   (Very likely you will need to switch to system Ruby using
#    "rvm reset" *before* installing gems with this script.)
#

set -x

# Remove extra repositories to avoid unnecessary downloads at repo refresh,
# we do not need the latest postgres, mysql, couchdb, rabbitmq, ...
# The standard Ubuntu repos in /etc/apt/sources.list are kept.
sudo rm /etc/apt/sources.list.d/*

# BASE URL on OBS project, so it works with same script for all supported branches.
OBS_PROJECT=$(sed -n '/obs_project =/s/^.*\"\(.*\)\".*$/\1/p' Rakefile)
case $OBS_PROJECT in
  # SLE-12
  Devel:YaST:SLE-12)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/SLE-12:/GA:/Travis/xUbuntu_12.04"
    ;;
  # OpenSUSE 13.2
  YaST:openSUSE:13.2)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/openSUSE:/13.2:/Travis/xUbuntu_12.04"
    ;;
  # storage-ng
  YaST:storage-ng)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/Head:/Travis/xUbuntu_12.04
               http://download.opensuse.org/repositories/YaST:/storage-ng:/Travis/xUbuntu_12.04"
    ;;
  # master
  *)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/Head:/Travis/xUbuntu_12.04"
    ;;
esac

# prepare the system for installing additional packages from OBS
for REPO_URL in $REPO_URLS; do
  curl $REPO_URL/Release.key | sudo apt-key add -
  echo "deb $REPO_URL/ ./" | sudo tee -a /etc/apt/sources.list
done

sudo apt-get update -q

while getopts ":p:g:" opt; do
  case $opt in
    # install packages
    p)
      sudo apt-get install --no-install-recommends $OPTARG
      ;;
    # install Ruby gems
    g)
      # install Ruby headers (needed to compile binary gems)
      sudo apt-get install ruby-dev
      sudo gem install $OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

