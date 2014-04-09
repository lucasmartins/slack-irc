require "bundler"
require_relative 'slack_relay'

task :default => :run

desc "run the shit"
task :run do
	SlackRelay.client.run!  # start EventMachine loop
end