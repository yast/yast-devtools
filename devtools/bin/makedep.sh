#!/bin/bash

# Make YCP modules dependencies
# Michal Svec <msvec@suse.cz>
#
# $Id$

modules="$(echo *.ycp)"
modulesregex="\"($(echo "$modules "|sed 's/\(\<[^ ]\+\)\>\.ycp /\1|/g'))\""
depfile=".dep"

#for m in *.ycp; do
#    echo "$m: \\"|sed "s|ycp|ybc|g"
#    grep '^[	 ]*import' $m | grep -E "$modulesregex" |
#	sed "s/.*\"\(.*\)\".*/	\1.ybc \\\\/g"
#    echo "	$depfile"
#    echo
#done

for m in *.ycp; do
    imports="$(grep '^[	 ]*import' $m | grep -E "$modulesregex")"
    [ -z "$imports" ] && continue

    echo -n "$m:"|sed "s|ycp|ybc|g"
    echo "$imports" | sort -u |
	while read i; do
	    echo ' \'
	    echo -en "\t$(echo "$i" | sed "s/.*\"\(.*\)\".*/\1.ybc/g")"
	done
    echo
    echo
done
