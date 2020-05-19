# frozen_string_literal: true

require 'challenges/programming/irc'
require 'base64'

irc = IRC.new
irc.send('PRIVMSG Candy :!ep3')
match = irc.expect(/PRIVMSG #{ARGV[0]} :(?<enc>\w+)/)
result = match[:enc].tr("A-Za-z", "N-ZA-Mn-za-m")
irc.send("PRIVMSG Candy :!ep3 -rep #{result}")
irc.expect(/You dit it!/)
