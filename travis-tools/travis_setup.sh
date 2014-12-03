#!/bin/sh
#
# Prepare a Travis node for running Yast build:
#
# - import YaST:openSUSE:13.2:Travis OBS repository GPG key
# - add YaST:openSUSE:13.2:Travis OBS repository
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

REPO_URL="http://download.opensuse.org/repositories/YaST:/openSUSE:13.2:/Travis/xUbuntu_12.04"

# prepare the system for installing additional packages from OBS
curl $REPO_URL/Release.key | sudo apt-key add -
echo "deb $REPO_URL/ ./" | sudo tee -a /etc/apt/sources.list

sudo apt-get update -q

while getopts ":p:g:" opt; do
  case $opt in
    # install packages
    p)
      sudo apt-get install --no-install-recommends $OPTARG
      ;;
    # install Ruby gems
    g)
      sudo gem install $OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

