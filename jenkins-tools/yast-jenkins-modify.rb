#! /usr/bin/env ruby
require "fileutils"
require "yaml"

# script for mass create of jobs in our jenkins
# credentials stored in jenkins.yml
# modify `config.xml` if needed ( git path will be automatic modify )
# modify JOB_NAME_PATTERN before use to specify pattern of job to delete

conf = YAML.load(File.read("jenkins.yml"))
USER = conf["user"]
PWD  = conf["pwd"]

# %s is replaced by arguments passed to program
JOB_NAME_PATTERN = "yast-%s-master"

URL_BASE = "https://#{USER}:#{PWD}@ci.opensuse.org"
#URL_BASE = "http://river.suse.de"

# modules that do not follow yast-{mod} convention
SPECIAL_MOD_NAMES = [
  "skelcd-control-SLES",
  "skelcd-control-SLED",
  "skelcd-control-openSUSE",
  "skelcd-control-openSUSE-LangAddOn",
  "skelcd-control-SLES-for-VMware",
  "y2r"
]

# All jobs on Jenkins have the name "yast-$MODULE-$BRANCH", but ARGV gets just a list of $MODULE
ARGV.each do |mod|
  #test if module already exist
  response_code = `curl -sL -w "%{http_code}" #{URL_BASE}/job/#{JOB_NAME_PATTERN % mod}/ -o /dev/null`
  raise "module #{mod} do not exists" unless response_code == "200"

  FileUtils.rm_f "config.xml.tmp"
  git_name = SPECIAL_MOD_NAMES.include?(mod) ? mod : "yast-#{mod}"
  # now modify config.xml to fit given module
  `sed 's/yast-[a-z_-]*\.git/#{git_name}.git/' config.xml > config.xml.tmp`

  # adress found from https://ci.opensuse.org/api
  cmd = "curl -X POST #{URL_BASE}/job/#{JOB_NAME_PATTERN % mod}/config.xml --header \"Content-Type:application/xml\" -d @config.xml.tmp"
  puts "Sending data for module #{git_name} with #{cmd}"
  res = `#{cmd}`
  puts "ERROR: curl exited with non-zero value" if $?.exitstatus != 0
  puts case res
    when ""
      "Succeed"
    when /Authentication required/
      "ERROR: Wrong Credentials. \n #{res}"
    else
      "non-standard response: #{res}"
    end
end
