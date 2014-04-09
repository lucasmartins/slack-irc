require 'eventmachine'

class SlackRelayServer < EventMachine::Connection
	def initialize
		super
		SlackRelay.client.run!  # start EventMachine loop
	end

  def post_init
    #send_data 'Hello'
  end

  def receive_data(data)
    p data
  end
end