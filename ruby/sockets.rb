#!/usr/bin/ruby -w

require "socket"
require "timeout"

TCPSocket.open("www.google.com", 80) do |socket|
	socket.puts "GET /HTTP/.0\n\n"
	puts socket.read
end
