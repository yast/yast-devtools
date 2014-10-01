#! /usr/bin/env ruby
require "rexml/document"

# script for geting all yast jobs matching JOB_NAME_REGEXP where parens enclosed are name

JOB_NAME_REGEXP = /\Ayast-(.*)-master\z/

#test if module already exist
all_modules = `curl -sL  http://ci.opensuse.org/view/Yast/api/xml`
#all_modules = `curl -sL  http://river.suse.de/view/YaST/api/xml`

raise "module list cannot load" if $?.exitstatus != 0

doc = REXML::Document.new all_modules

names = doc.root.elements.to_a("//name").
  map(&:get_text).
  select{ |n| n.to_s =~ JOB_NAME_REGEXP}.
  map{ |n| n.to_s.sub(JOB_NAME_REGEXP, "\\1") }

print names.join("\n")
