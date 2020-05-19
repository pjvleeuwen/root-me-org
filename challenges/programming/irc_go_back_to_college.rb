# frozen_string_literal: true

require 'socket'
require 'io/wait'

raise 'ARGV[0] must be username' unless ARGV.size >= 1 && ARGV[0].size >= 1

# IRC IO handling
class IRC
  def initialize(server, port)
    @irc = TCPSocket.open(server, port)
  end

  def fail_response(pattern, response)
    send('QUIT')
    raise IOError, "unexpected response\n" \
                   "EXPECTED: #{pattern.inspect}\n" \
                   "RECEIVED:\n#{response.inspect}"
  end

  def expect(pattern, timeout = 10)
    response = ''
    while @irc.wait_readable(timeout)
      response += @irc.read(@irc.nread)
      match = pattern.match(response)
      response.each_line { |line| puts "RECV> #{line}" }
      return match if match
    end
    fail_response(pattern, response)
  end

  def send(command)
    puts "SENT> #{command}"
    @irc.puts(command)
  end
end

irc = IRC.new('irc.root-me.org', '6667')
irc.expect(/Looking up your hostname\.\.\./)

irc.send("USER #{ARGV[0]} 0 * #{ARGV[0]}")
irc.send("NICK #{ARGV[0]}")
irc.expect(/MODE #{ARGV[0]}/)

irc.send('JOIN #root-me_challenge')
irc.expect(%r{End of /NAMES list})

irc.send('PRIVMSG Candy :!ep1')
match = irc.expect(%r{PRIVMSG #{ARGV[0]} :(?<n1>\d+) / (?<n2>\d+)})
result = (Math.sqrt(match[:n1].to_i) * match[:n2].to_i).round(2)

irc.send("PRIVMSG Candy :!ep1 -rep #{result}")
irc.expect(/You dit it!/)
