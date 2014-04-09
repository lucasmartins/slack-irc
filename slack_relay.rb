require 'em-irc'
require 'logger'

REQUIRED_VARS=[
  'SLACK_TOKEN',
  'SLACK_ACCOUNT',
  'SLACK_CHANNEL',
  'IRC_SERVER',
  'IRC_PORT',
  'IRC_ACCOUNT',
  'IRC_CHANNEL'
]

REQUIRED_VARS.each do |v|
  raise "You MUST export this environment variable: #{v}" unless ENV[v]
end

class SlackRelay
  # Tiphoeus here?
  def self.push(source, target, message)
    message=" #{message}" if message.start_with?(':')
    `curl -X POST --data-urlencode 'payload={"channel": "##{ENV['SLACK_CHANNEL']}", "username": "[IRC] #{source}", "text": "#{message}", "icon_emoji": ":ghost:"}' https://#{ENV['SLACK_ACCOUNT']}.slack.com/services/hooks/incoming-webhook?token=#{ENV['SLACK_TOKEN']} -s`
  end

  def self.client
    client = EventMachine::IRC::Client.new do
      host ENV['IRC_SERVER']
      port ENV['IRC_PORT']

      on(:connect) do
        nick(ENV['IRC_ACCOUNT'])
      end

      on(:nick) do
        join("##{ENV['IRC_CHANNEL']}")
      end

      on(:join) do |channel|  # called after joining a channel
        message(channel, " :ok_hand: Your IRC bridge is up and :running: on ##{ENV['IRC_CHANNEL']}...")
        message(channel, "don't be shy, send a Pull Request to http://github.com/lucasmartins/slack-irc with your fix or feature.")
      end

      on(:message) do |source, target, message|  # called when being messaged
        SlackRelay.push(source, target, message)
      end

      # callback for all messages sent from IRC server
      on(:parsed) do |hash|
        puts "#{hash[:prefix]} #{hash[:command]} #{hash[:params].join(' ')}"
      end
    end
  end

  def self.server
    EventMachine.run {
      EventMachine.start_server '127.0.0.1', ENV['PORT'], Echo
    }
  end
end
