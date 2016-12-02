require "base64"
require "./B16B5/constants"
require "./B16B5/helper"
require "./B16B5/cipher"
require "./B16B5/arguments"

include B16B5

args = Argument.new
fulldata = args.input.gets_to_end.bytes            # TODO: use IO to encrypt / decrypt without memory overusage
key = args.key.gets_to_end.bytes[0...B16B5::BLOCK] # TODO: use the full key

output = nil
if args.mode == :encrypt
  output = feistel_encrypt(fulldata, key, args.rounds)
  # output = Base64.strict_encode(output.map(&.chr).join("")).bytes if args.ascii
else
  # fulldata = Base64.decode_string(fulldata.map(&.chr).join("")).bytes if args.ascii
  output = feistel_decrypt(fulldata, key, args.rounds)
end

args.output.write Slice(UInt8).new(output.to_unsafe, output.size)
args.output.flush
