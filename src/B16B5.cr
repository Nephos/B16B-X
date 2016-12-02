require "./B16B5/helper"

module B16B5
  BLOCK           = 2
  HALF_BLOCK      = BLOCK / 2
  BLOCK_BITS      = BLOCK * 8
  HALF_BLOCK_BITS = HALF_BLOCK * 8

  alias Block = UInt16
  alias HalfBlock = UInt8
  alias Byte = UInt8
end

require "./B16B5/cipher"

include B16B5

DATA = "012345678".bytes
fulldata = DATA + Array.new((B16B5::BLOCK - DATA.size) % B16B5::BLOCK) { 0_u8 }

KEY = "abcd"[0...B16B5::BLOCK].bytes
key = KEY # .blockvalue

VECTOR = "xu1a"[0...B16B5::BLOCK].bytes

p fulldata
p key

puts "ENCRYPT"
encrypteddata = feistel_encrypt(fulldata, key)
puts "\n"
puts "DECRYPT"
decrypteddata = feistel_decrypt(encrypteddata, key)

# puts "--"
puts "Original  = " + fulldata.map { |e| e.to_s.rjust(3, '0') }.join(" ")
puts "Encrypted = " + encrypteddata.map { |e| e.to_s.rjust(3, '0') }.join(" ")
puts "Decrypted = " + decrypteddata.map { |e| e.to_s.rjust(3, '0') }.join(" ")
puts "Finished  = " + decrypteddata.map(&.chr).join("")
