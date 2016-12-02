module B16B5
  BLOCK           = 4
  HALF_BLOCK      = BLOCK / 2
  BLOCK_BITS      = BLOCK * 8
  HALF_BLOCK_BITS = HALF_BLOCK * 8

  alias Block = UInt32
  alias HalfBlock = UInt16
  alias Byte = UInt8
end
