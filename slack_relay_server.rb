require 'eventmachine'
require 'cgi'

class SlackRelayServer < EventMachine::Connection
  def post_init
    #SlackRelay.client.message('from','to','message')
  end

  def receive_data(data)
    data = CGI::parse(data)
    p data
    username = data['user_name'].first
    if username=='slackbot'
      puts 'discarded message'
    else
      puts "[slack][#{username}]: #{data['text'].first}"
    end
  end
end