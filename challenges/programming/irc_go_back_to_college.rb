# frozen_string_literal: true

require 'challenges/programming/irc'

irc = IRC.new
irc.send('PRIVMSG Candy :!ep1')
match = irc.expect(%r{PRIVMSG #{ARGV[0]} :(?<n1>\d+) / (?<n2>\d+)})
result = (Math.sqrt(match[:n1].to_i) * match[:n2].to_i).round(2)

irc.send("PRIVMSG Candy :!ep1 -rep #{result}")
irc.expect(/You dit it!/)
