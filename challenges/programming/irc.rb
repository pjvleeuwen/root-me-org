# frozen_string_literal: true

require 'socket'
require 'io/wait'

raise 'ARGV[0] must be username' unless ARGV.size >= 1 && ARGV[0].size >= 1

# IRC IO handling
class IRC
  def initialize
    @irc = TCPSocket.open('irc.root-me.org', '6667')
    expect(/Looking up your hostname\.\.\./)
    send("USER #{ARGV[0]} 0 * #{ARGV[0]}")
    send("NICK #{ARGV[0]}")
    expect(/MODE #{ARGV[0]}/)
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
