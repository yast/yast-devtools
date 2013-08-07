# encoding: utf-8
#
# Converts static YCP data file from YCP format to YAML format
# 
# Example usage:
#   /sbin/yast2 ycp2yml /usr/share/YaST2/data/consolefonts.ycp consolefonts.yml
#   
# NOTE: The input YCP file is evaluated and the result is saved into YML file,
# it does not convert the actions inside the YCP file, only the evaluated result.
#
# This means that e.g. translations will not work as expected, the comments
# will be lost, etc...
# 
# Do not use it for other YCP files which contain code (modules, clients),
# that will not work!!
#


require 'yaml'

module Yast
  class Ycp2YmlClient < Client
    def main
      # parse_options
      from = WFM.Args(0)
      to = WFM.Args(1)

      if (from && !from.empty? && to && !to.empty?)
        puts "Converting #{from} to #{to}..."

        # run the conversion
        convert(from, to)
      end
    end

    def convert(from, to)
      data = SCR.Read(path(".target.ycp"), from)
      File.open(to, 'w') {|f| f.write(data.to_yaml) }
    end
  end
end

Yast::Ycp2YmlClient.new.main
