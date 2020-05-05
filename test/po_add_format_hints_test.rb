#!/usr/bin/env rspec

require_relative "../build-tools/scripts/po_add_format_hints.rb"

describe Yast::GetText::Tools::PoAddFormatHints do
  subject { described_class.new }
  
  describe "#new" do
    it "Does not crash and burn" do
      expect(subject).not_to be_nil
    end

    it "Starts with reasonable defaults" do
      expect(subject.dry_run).to be false
      expect(subject.verbose).to be false
      expect(subject.silent).to be false
      expect(subject.total_modifications).to be == 0
      expect(subject.current_file_modifications).to be == 0
    end
  end

  describe "#find_known_formats" do
    it "Detects simple printf-like format strings: %s, %d, %x, ..." do
      expect(subject.find_known_formats("%s")).to be == "c-format"
      expect(subject.find_known_formats("foo %s bar")).to be == "c-format"
      expect(subject.find_known_formats("foo %d bar")).to be == "c-format"
      expect(subject.find_known_formats("foo %02x bar")).to be == "c-format"
      expect(subject.find_known_formats("foo %1d bar")).to be == "c-format"
      expect(subject.find_known_formats("foo %2s bar")).to be == "c-format"
    end
    
    it "Detects more complex printf-like format strings: %-10.4d" do
      expect(subject.find_known_formats("%2.1d")).to be == "c-format"
      expect(subject.find_known_formats("%-10.4d")).to be == "c-format"
      expect(subject.find_known_formats("%+10.4d")).to be == "c-format"
      expect(subject.find_known_formats("% 10.4d")).to be == "c-format"
    end

    it "Detects positional parameters in printf-like format strings: %1$d, %2$s, ..." do
      expect(subject.find_known_formats("%1$d")).to be == "c-format"
      expect(subject.find_known_formats("%1$s")).to be == "c-format"
      expect(subject.find_known_formats("%2$s %1$s")).to be == "c-format"
    end
    
    it "Detects sformat-like format strings: %1, %2, ..." do
      expect(subject.find_known_formats("foo %1 bar")).to be == "ycp-format"
      expect(subject.find_known_formats("%2 foo %1 bar")).to be == "ycp-format"
    end

    it "Detects named parameters: %{foo}, %{bar}" do
      expect(subject.find_known_formats("%{foo} is %{bar}")).to be == "perl-brace-format"
    end

    it "Ignores named parameters with format spec: %<foo>s, %<bar>d" do
      expect(subject.find_known_formats("%<foo>s is %<bar>d")).to be == nil
    end
    
    it "Survives inconsistent formats: %1 %2d (c-format wins)" do
      expect(subject.find_known_formats("%1 %2d")).to be == "c-format"
      expect(subject.find_known_formats("%1s %2")).to be == "c-format"
    end

    it "Can handle embedded newlines" do
      expect(subject.find_known_formats("foo\nbar\n%s bar")).to be == "c-format"
    end

    it "Ignores named parameters if perl-brace-format is disabled" do
      subject.perl_brace_format = false
      expect(subject.find_known_formats("%{foo} is %{bar}")).to be == nil
      subject.perl_brace_format = true
      expect(subject.find_known_formats("%{foo} is %{bar}")).to be == "perl-brace-format"
    end
  end
end
