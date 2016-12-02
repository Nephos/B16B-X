module B16B5
  def feistel_encrypt(fulldata : Array(Byte), key : Array(Byte), rounds : Int32) : Array(Byte)
    # Padding
    padding = Array.new((B16B5::BLOCK - fulldata.size) % B16B5::BLOCK) { 0_u8 }
    fulldata = fulldata + padding
    # Subkey generation
    subkeys = generate_subkeys(key, rounds)
    # Encryption
    map_feistel_rounds(fulldata) do |left, right|
      encrypt_round(left, right, subkeys.dup, rounds)
    end
  end

  def feistel_decrypt(fulldata : Array(Byte), key : Array(Byte), rounds : Int32) : Array(Byte)
    # Subkey generation
    subkeys = generate_subkeys(key, rounds).reverse
    # Decryption
    map_feistel_rounds(fulldata) do |left, right|
      decrypt_round(left, right, subkeys.dup, rounds)
    end
    # TODO: remove extra padding
  end

  private def map_feistel_rounds(fulldata)
    map_blocks(fulldata) do |block|
      left = block.high
      right = block.low
      left, right = yield(left, right)
      left.merge(right)
    end.map { |b| b.blockdata }.flatten
  end

  private def map_blocks(fulldata : Array(Byte), &b)
    output = Array(Block).new
    fulldata.each_slice(BLOCK) do |block|
      output << yield block.blockvalue
    end
    output
  end

  private def generate_subkeys(masterkey : Array(Byte), rounds : Int32) : Array(HalfBlock)
    keys = rounds.times.map { |i| masterkey.blockvalue.lshift(i).low }.to_a
  end

  private def encrypt_round(left : HalfBlock, right : HalfBlock,
                            keys : Array(HalfBlock), rounds : Int) : Tuple(HalfBlock, HalfBlock)
    key = keys.pop
    new_left = right
    new_right = left ^ key ^ right
    rounds > 1 ? encrypt_round(new_left, new_right, keys, rounds - 1) : {new_left, new_right}
  end

  private def decrypt_round(left : HalfBlock, right : HalfBlock,
                            keys : Array(HalfBlock), rounds : Int) : Tuple(HalfBlock, HalfBlock)
    key = keys.pop
    new_right = left
    new_left = left ^ key ^ right
    rounds > 1 ? decrypt_round(new_left, new_right, keys, rounds - 1) : {new_left, new_right}
  end
end
