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
  Devel:YaST:SLE-12-SP2 | Devel:YaST:CASP:1.0)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/SLE-12:/SP2:/Travis/xUbuntu_12.04"
    ;;
  Devel:YaST:SLE-12-SP1)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/SLE-12:/SP1:/Travis/xUbuntu_12.04"
    ;;
  # SLE-12
  Devel:YaST:SLE-12)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/SLE-12:/GA:/Travis/xUbuntu_12.04"
    ;;
  # OpenSUSE 13.2
  YaST:openSUSE:13.2)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/openSUSE:/13.2:/Travis/xUbuntu_12.04"
    ;;
  # OpenSUSE 42.1
  YaST:openSUSE:42.1)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/openSUSE:/42.1:/Travis/xUbuntu_12.04"
    ;;
  # OpenSUSE 42.2
  YaST:openSUSE:42.2)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/openSUSE:/42.2:/Travis/xUbuntu_12.04"
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

# Handle the new way (Yast::Tasks.submit_to :sle12sp1)
# See https://github.com/yast/yast-rake/blob/master/data/targets.yml
SUBMIT_TO=$(sed -n '/submit_to */s/^.*:\([^ \t]*\)/\1/p' Rakefile)
# If submit_to has any value, this overrides the previously set variables.
# If it's blank, it does nothing (respect previous values).
case $SUBMIT_TO in
  sle12sp3*)
  # SLE-12-SP3
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/SLE-12:/SP3:/Travis/xUbuntu_12.04"
    ;;
  # SLE-12-SP2
  sle12sp2*)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/SLE-12:/SP2:/Travis/xUbuntu_12.04"
    ;;
  # SLE-12-SP1
  sle12sp1*)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/SLE-12:/SP1:/Travis/xUbuntu_12.04"
    ;;
  # SLE-12-GA
  sle12)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/SLE-12:/GA:/Travis/xUbuntu_12.04"
    ;;
  # OpenSUSE Leap 42.1
  leap_42_1)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/openSUSE:/42.1:/Travis/xUbuntu_12.04"
    ;;
  # OpenSUSE Leap 42.2
  leap_42_2)
    REPO_URLS="http://download.opensuse.org/repositories/YaST:/openSUSE:/42.2:/Travis/xUbuntu_12.04"
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

