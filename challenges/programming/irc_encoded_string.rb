# frozen_string_literal: true

require 'challenges/programming/irc'
require 'base64'

irc = IRC.new
irc.send('PRIVMSG Candy :!ep2')
match = irc.expect(/PRIVMSG #{ARGV[0]} :(?<enc>\w+)/)
result = Base64.decode64(match[:enc])

irc.send("PRIVMSG Candy :!ep2 -rep #{result}")
irc.expect(/You dit it!/)
