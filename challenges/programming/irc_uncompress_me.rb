# frozen_string_literal: true

require 'challenges/programming/irc'
require 'base64'
require 'zlib'

irc = IRC.new
irc.send('PRIVMSG Candy :!ep4')
match = irc.expect(/PRIVMSG #{ARGV[0]} :(?<enc>\w+)/)
result = Zlib::Inflate.inflate(Base64.decode64(match[:enc]))
irc.send("PRIVMSG Candy :!ep4 -rep #{result}")
irc.expect(/You dit it!/)
