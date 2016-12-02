# TODO T = UInt8
class Array(T)
  # TODO : generic block size
  # merge the bytes in a single value
  def blockvalue : B16B5::Block
    map { |v| Block.new(v) }.reduce { |l, r| (l << 8) + r }
  end
end

struct Int
  # split the integer in muliples bytes
  def blockdata(size = B16B5::BLOCK) : Array(UInt8)
    res = (size - 1).downto(0).map do |i|
      ((self & (0xFF << (i * 8))) >> (i * 8)).to_u8
    end.to_a
    res
  end

  # left circular shift
  def lshift(n, bits = B16B5::BLOCK) : B16B5::Block
    remain = bits - n
    low = self >> remain
    high = self << n
    high | low
  end

  # right circular shift
  def rshift(n, bits = B16B5::BLOCK) : B16B5::Block
    remain = bits - n
    low = self >> n
    high = self << remain
    high | low
  end

  def high : B16B5::HalfBlock
    HalfBlock.new(self >> B16B5::HALF_BLOCK_BITS)
  end

  def low : B16B5::HalfBlock
    HalfBlock.new(self & B16B5::HalfBlock::MAX)
  end

  def merge(right : B16B5::HalfBlock) : B16B5::Block
    v = (B16B5::Block.new(self) << B16B5::HALF_BLOCK_BITS) | (B16B5::Block.new(right) & B16B5::HalfBlock::MAX)
    v
  end
end
