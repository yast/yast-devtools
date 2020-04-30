#!/usr/bin/env ruby
#
# encoding: utf-8

# Copyright (c) [2020] SUSE LLC
#
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, contact SUSE LLC.
#
# To contact SUSE LLC about this file by physical or electronic mail, you may
# find current contact information at www.suse.com.

#
# ---------------------------------------------------------------------------
#
# This script will add format marker hints to .po and .pot files:
#
#   %s %d etc. -> c-format
#   %1 %2 etc. -> ycp-format
#
# msgfmt and msgmerge understand those formats and will check if a translation
# has the same placeholders as the untranslated message.
#
# This script is usually called from y2makepot (which is called via "rake pot")
# after creating a .pot file from Ruby source code with "rxgettext" (from
# package rubygem-gettext). It uses the same .po parser as "rxgettext".
#
# Usage:
#
#   po_add_format_hints [-n|--dry-run] [-v|--verbose] mymessages.pot
#
#   -n, --dry-run :  dry run; don't modify the file.
#   -v, --verbose :  more output
#
# It is NOT necessary to call this for each .po file for each language as well:
# The "msgmerge" command will do that while it merges new or changed messages
# from the .pot file into each .po file for each language.
#
# Author: Stefan Hundhammer <shundhammer@suse.com>
#

require "optparse"
require "gettext"
require "gettext/po_parser"
require "gettext/po"

module Yast
  module GetText
    module Tools
      # Class to add format marker hints to .po and .pot files
      class PoAddFormatHints
        def initialize
          @dry_run = false
          @verbose = false
          @po_format_options =
          {
            :max_line_width => ::GetText::POEntry::Formatter::DEFAULT_MAX_LINE_WIDTH
          }
          @po_parser = nil
        end

        def run(command_line_args)
          po_files = parse_command_line(command_line_args)
          po_files.each { |po_file| add_format_hints(po_file) }
        end

        def add_format_hints(po_file)
          po = read_po(po_file)
          puts("Parsing #{po_file} (#{po.entries.size} entries)") if @verbose
          detect_formats(po)
          write_po(po_file, po) unless @dry_run
          po
        end

        def read_po(po_file)
          raise ArgumentError, "Can't open #{po_file}" unless File.exist?(po_file)
          po = ::GetText::PO.new
          po_parser.parse_file(po_file, po)
          po
        end
        
        def write_po(po_file, po)
          po_string = po.to_s(@po_format_options)
          if po_string.empty?
            STDERR.puts("#{$0}: No output for #{po_file}")
            return false
          end
          File.open(po_file, "w") do |file|
            file.print(po_string)
          end
          true
        end
        
        def detect_formats(po)
          po.each do |entry|
            next if entry.msgid.empty?
            msg = entry.msgid.chomp
            # puts("Checking \"#{msg}\"") if @verbose
            format = find_known_formats(msg)
            if format
              puts("* Detected #{format} in \"#{msg}\"") if @verbose
              entry.flags << format unless entry.flags.include?(format)
            end
          end
        end

        def find_known_formats(msg)
          case msg
          when /%[sdixXoeEfgGbB]/ # simple printf-like %s %d %x ...
            puts("  Detected simple printf()-like format") if @verbose
            "c-format"
          when /%[0-9]*\$[sdixXoeEfgGbB]/
            puts("  Detected positional parameters in printf()-like format") if @verbose
            "c-format"
          when /%-?[0-9]+[sdixXoeEfgGbB]/, /%-?[0-9]+\.[0-9]+[sdixXoeEfgGbB]/
            # More elaborate printf-like formats.
            # Notice this does not catch all weird cases, but a translator
            # should not confronted with this anyway; this should be formatted
            # into a string first and THEN put into a message that the
            # translator sees.
            puts("  Detected complex printf()-like format") if @verbose
            "c-format"
          when /%[1-9]/ # sformat-like %1 %2 %3 ...
            puts("  Detected sformat()-like positional parameters") if @verbose
            "ycp-format"
          else
            nil
          end
        end

        def po_parser
          @po_parser ||= create_po_parser
        end

        private

        # Parse the command line and modify internal flags accordingly.
        # Return the non-option command line arguments: The .po files to work on.
        def parse_command_line(command_line_args)
          parser = create_option_parser
          po_files = parser.parse(command_line_args)
          # Unfortunately, there is no better documented way to show the usage
          # and terminate the program if no other command line arguments were given.
          parser.parse("-h") if po_files.empty?
          po_files
        end

        def create_option_parser
          parser = OptionParser.new
          # parser.version = "1.0"
          parser.banner = ("Usage: %s [OPTIONS] PO_FILE1 [PO_FILE2] ...") % $0
          parser.separator("")
          parser.separator("Add PO format marker hints to .pot and .po files:")
          parser.separator("  %s %d etc. -> c-format")
          parser.separator("  %1 %2 etc. -> ycp-format")
          parser.separator("")
          parser.separator("The markers are added in-place unless the --dry-run option is given.")
          parser.separator("")
          parser.separator("Options:")

          parser.on("-n", "--dry-run", "Dry run; don't modify the file.") do |dry_run|
            @dry_run = dry_run
          end

          parser.on("-v", "--verbose", "More output") do |verbose|
            @verbose = verbose
          end

          parser
        end

        def create_po_parser
          po_parser ||= ::GetText::POParser.new
          po_parser.report_warning = true
          po_parser
        end
        
      end
    end
  end
end

if __FILE__ == $0 # if called as a standalone command
  Yast::GetText::Tools::PoAddFormatHints.new.run(ARGV)
end
