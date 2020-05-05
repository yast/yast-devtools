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
#   %s %d etc.    -> c-format
#   %1 %2 etc.    -> ycp-format
#   %{foo} %{bar} -> perl-brace-format
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
#   po_add_format_hints [OPTIONS] mymessages.pot [mymessages2.pot]
#
# Options:
#
#   -n, --dry-run :  dry run; don't modify the file.
#   -v, --verbose :  more output
#   -s, --silent  :  no output
#
# It is NOT necessary to call this for each .po file for each language as well:
# The "msgmerge" command will do that while it merges new or changed messages
# from the .pot file into each .po file for each language.
#
# Use a standard xgettext comment to override this script:
#
#   # xgettext:c-format
#   foo(_"... %1 ...")
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
        SHORT_MSG_LIMIT = 50
        attr_accessor :dry_run, :verbose, :silent, :perl_brace_format

        # Constructor
        def initialize
          @dry_run = false
          @verbose = false
          @silent = false
          @perl_brace_format = true
          @current_file_modifications = 0
          @total_modifications = 0
          @po_format_options =
          {
            :max_line_width => ::GetText::POEntry::Formatter::DEFAULT_MAX_LINE_WIDTH
          }
          @po_parser = nil
        end

        # Normal entry point if used as a standalone command.
        def run(command_line_args)
          po_files = parse_command_line(command_line_args)
          po_files.each { |po_file| add_format_hints(po_file) }
          if po_files.size > 1 && !@silent
            puts("Total: #{@total_modifications} format flags added")
          end
        end

        # Read and parse a .po or .pot file named 'po_file', check each entry
        # for format strings and add format flags accordingly. If there was any
        # modification and this is not a dry run, write the result back to the
        # same file.
        def add_format_hints(po_file)
          po = read_po(po_file)
          log_verbose("Parsing #{po_file} (#{po.entries.size} entries)")
          detect_formats(po)
          if @current_file_modifications > 0 && !@silent
            puts("#{po_file}: #{@current_file_modifications} format flags added")
          end
          write_po(po_file, po) unless @dry_run
          po
        end

        # Read a file named 'po_file' and return the corresponding PO object.
        def read_po(po_file)
          raise ArgumentError, "Can't open #{po_file}" unless File.exist?(po_file)
          po = ::GetText::PO.new
          po_parser.parse_file(po_file, po)
          @current_file_modifications = 0
          po
        end

        # Write a PO object 'po' to a file named 'po_file' unless there was no
        # modification.
        def write_po(po_file, po, force = false)
          if current_file_unmodified? && !force
            log_verbose("Not modified: #{po_file}")
            return
          end
          po_string = po.to_s(@po_format_options)
          if po_string.empty?
            STDERR.puts("#{$0}: No output for #{po_file}")
            return false
          end
          log_verbose("Writing #{po_file}")
          File.open(po_file, "w") do |file|
            file.print(po_string)
          end
          true
        end

        # Detect the formats in all messages in PO object 'po' and add them to
        # the flags of each entry. Leave entries alone that already have a
        # format flag (typically set by a commend starting with "xgettext:" in
        # the source file).
        def detect_formats(po)
          po.each do |entry|
            next if entry.msgid.empty?
            msg = entry.msgid.chomp
            if has_format_flag?(entry)
              log_verbose("  Skipping existing format: \"#{short_msg(msg)}\"")
              next
            end
            # log_verbose("Checking \"#{short_msg(msg)}\"")
            format = find_known_formats(msg)
            if format
              log_verbose("* Adding #{format} to \"#{short_msg(msg)}\"")
              entry.flags << format
              @current_file_modifications += 1
              @total_modifications += 1
            end
          end
        end

        # Check if a PO entry already has a format flag
        # ("c-format", "ycp-format", ...).
        def has_format_flag?(po_entry)
          po_entry.flags.any? { |flag| flag.end_with?("-format") }
        end

        # Check if a message contains any of the known formats.
        #
        # If yes, return that format as a string ("c-format", "ycp-format").
        # If no, return 'nil'.
        def find_known_formats(msg)
          case msg
          when /%[sdixXoeEfgGbB]/ # simple printf-like %s %d %x ...
            log_verbose("  Detected simple printf()-like format")
            "c-format"
          when /%[0-9]*\$[sdixXoeEfgGbB]/
            log_verbose("  Detected positional parameters in printf()-like format")
            "c-format"
          when /%-?[0-9]+[sdixXoeEfgGbB]/, /%-?[0-9]+\.[0-9]+[sdixXoeEfgGbB]/
            # More elaborate printf-like formats.
            # Notice this does not catch all weird cases, but a translator
            # should not confronted with this anyway; this should be formatted
            # into a string first and THEN put into a message that the
            # translator sees.
            log_verbose("  Detected complex printf()-like format")
            "c-format"
          when /%[1-9]/ # sformat-like %1 %2 %3 ...
            log_verbose("  Detected sformat()-like positional parameters")
            "ycp-format"
          when /%{[a-zA-Z][a-zA-Z0-9]*}/ # Named parameters %{foo} %{bar}
            if @perl_brace_format
              log_verbose("  Detected named parameters %{value}")
              "perl-brace-format"
            else
              log_verbose("  Detected named parameters %{value} (ignored as requested)")
              nil
            end
          when /%<[a-zA-Z][a-zA-Z0-9]*>/ # Named parameters %{foo} %{bar}
            log_verbose("  Detected named parameters %<value> (no suitable xgettext format flag)")
            nil
          else
            nil
          end
        end

        # Return the po parser; create it if it doesn't exist yet.
        def po_parser
          @po_parser ||= create_po_parser
        end

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

        private

        def create_option_parser
          parser = OptionParser.new
          # parser.version = "1.0"
          parser.banner = ("Usage: %s [OPTIONS] PO_FILE1 [PO_FILE2] ...") % File.basename($0)
          parser.separator("")
          parser.separator("Add PO format marker hints to .pot and .po files:")
          parser.separator("  \"%s %d\" etc.         -> c-format")
          parser.separator("  \"%1 %2\" etc.         -> ycp-format")
          parser.separator("  \"%{foo} %{bar}\" etc. -> perl-brace-format")
          parser.separator("")
          parser.separator("The markers are added in-place unless the --dry-run option is given.")
          parser.separator("")
          parser.separator("Use the usual xgettext comments to override this:")
          parser.separator("  # xgettext:c-format")
          parser.separator("  foo(_(\"... %1 ...\"))")
          parser.separator("")
          parser.separator("Options:")

          parser.on("-n", "--dry-run", "Dry run; don't modify the file.") do |dry_run|
            @dry_run = dry_run
          end

          parser.on("-p", "--no-perl-brace-format", "Don't use the perl-brace-format") do |p|
            @perl_brace_format = false
          end

          parser.on("-v", "--verbose", "More output") do |verbose|
            @verbose = verbose
          end

          parser.on("-s", "--silent", "No output") do |silent|
            @silent = silent
          end

          parser
        end

        def create_po_parser
          po_parser ||= ::GetText::POParser.new
          po_parser.report_warning = true
          po_parser
        end

        # Write a message to stdout if the --verbose command line option was set
        def log_verbose(msg)
          puts(msg) if @verbose
        end

        # Return a message suitable for debug output:
        # All newlines translated to "\n" and 50 chars max
        def short_msg(msg)
          result = msg.chomp.gsub("\n", "\\n")
          return result if result.size <= SHORT_MSG_LIMIT
          result[0..SHORT_MSG_LIMIT-1] + "..."
        end

        def current_file_unmodified?
          @current_file_modifications == 0
        end
      end
    end
  end
end

if __FILE__ == $0 # if called as a standalone command
  Yast::GetText::Tools::PoAddFormatHints.new.run(ARGV)
end
