require "bundler"
require_relative 'slack_relay'

task :default => :version

desc "run the shit"
task :run do
	SlackRelay.client.run!  # start EventMachine loop
end

desc "shows the shit version"
task :version do
	puts '0.0.0'
end