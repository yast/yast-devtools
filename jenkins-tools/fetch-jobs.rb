#!/usr/bin/env ruby
#
# This script get jobs configurations. It relies on jenkins_api_client gem
# instead of Jenkins Java CLI, so it's quiet fast.
#
#   ruby fetch-jobs.rb --config ci-jenkins.yml --prefix yast- --output configs
#
# You can get more information using the --help option:
#
#   ruby fetch-jobs.rb --help
begin
  require "jenkins_api_client"
rescue LoadError
  STDERR.puts "You need to install rubygem-jenkins_api_client package"
  exit 1
end
require "yaml"
require "pathname"
require "optparse"
require "fileutils"

module GetJobs
  class Application
    def initialize(argv)
      opts = parse_options(argv)
      @client = JenkinsApi::Client.new(YAML.load_file(opts[:config]))
      @prefix = opts[:prefix]
      @output = Pathname(opts[:output])
    end

    def run
      FileUtils.mkdir_p(@output) unless Dir.exist?(@output)
      @client.job.list(@prefix).each do |name|
        job_config = @client.job.get_config(name)
        File.open(@output.join("#{name}.xml").to_s, "w+") do |f|
          f.puts job_config
        end
      end
    end

    private

    def parse_options(argv)
      opts = { config: "jenkins.yml", prefix: "yast-", output: "jobs" }
      parser = OptionParser.new
      parser.banner = "Usage: fetch-jobs.rb [options]"
      parser.separator ""
      parser.on("-c", "--config CONFIG", "Jenkins configuration file") do |config|
        opts[:config] = config
      end
      parser.on("-p", "--prefix PREFIX", "Jobs prefix") do |prefix|
        opts[:prefix] = prefix
      end
      parser.on("-d", "--output DIRECTORY", "Output directory") do |output|
        opts[:output] = output
      end
      parser.on_tail("-h", "--help", "Display help") do
        puts parser
        exit
      end
      parser.parse!(argv)
      opts
    end
  end
end

GetJobs::Application.new(ARGV).run
