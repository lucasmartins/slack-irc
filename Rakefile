require "bundler"
require_relative 'slack_relay'
require_relative 'slack_relay_server'

task :default => :version

desc "run the shit"
task :run do
	EventMachine.run {
    SlackRelay.client.run!  # start EventMachine loop
	  EventMachine.start_server '127.0.0.1', ENV['PORT'], SlackRelayServer
	}
end

desc "shows the shit version"
task :version do
	puts '0.0.0'
end