# script for mass delete of jobs in our jenkins
# credentials stored in jenkins.yml
# modify JOB_NAME_PATTERN before use to specify pattern of job to delete

require "yaml"

conf = YAML.load(File.read("jenkins.yml"))
USER = conf["user"]
PWD  = conf["pwd"]
# %s is replaced by arguments passed to program
JOB_NAME_PATTERN = "yast-%s-test"

ARGV.each do |mod|
  # address to delete from http://jenkins-ci.361315.n4.nabble.com/Deleting-a-job-through-the-Remote-API-td3622851.html
  `curl -X POST https://#{USER}:#{PWD}@ci.opensuse.org/job/#{JOB_NAME_PATTERN %  mod}/doDelete`
end
