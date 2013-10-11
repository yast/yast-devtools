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

ARGV.each do |mod|
  #test if module already exist
  response_code = `curl -sL -w "%{http_code}" https://#{USER}:#{PWD}@ci.opensuse.org/view/Yast/job/yast-#{mod}-master/ -o /dev/null`
  next if response_code == "200"

  FileUtils.rm_f "config.xml.tmp"
  # now modify config.xml to fit given module
  `sed 's/yast-.*\.git/yast-#{mod}.git/' config.xml > config.xml.tmp`

  # adress found from https://ci.opensuse.org/api
  res = `curl -X POST https://#{USER}:#{PWD}@ci.opensuse.org/createItem?name=#{JOB_NAME_PATTERN % mod} --header "Content-Type:application/xml" -d @config.xml.tmp`
  puts "ERROR: #{res}" if $?.exitstatus != 0
  puts "ERROR: Wrong Credentials. \n #{res}" if res =~ /Authentication required/
end
