module B16B5
  ROUNDS = 2

  private def map_feistel_rounds(fulldata)
    map_blocks(fulldata) do |block|
      left = block.high
      right = block.low
      puts "block: #{block}, #{block.to_s 2}"
      puts "left: #{left}, #{left.to_s 2}"
      puts "right: #{right}, #{right.to_s 2}"
      puts "merge: #{left.merge(right)}, #{left.merge(right).to_s 2}"
      left, right = yield(left, right)
      left.merge(right)
    end.map { |b| b.blockdata }.flatten
  end

  def feistel_encrypt(fulldata : Array(Byte), key : Array(Byte)) : Array(Byte)
    subkeys = generate_subkeys(key, ROUNDS)
    map_feistel_rounds(fulldata) do |left, right|
      encrypt_round(left, right, subkeys.dup, ROUNDS)
    end
  end

  def feistel_decrypt(fulldata : Array(Byte), key : Array(Byte)) : Array(Byte)
    subkeys = generate_subkeys(key, ROUNDS).reverse
    map_feistel_rounds(fulldata) do |left, right|
      decrypt_round(left, right, subkeys.dup, ROUNDS)
    end
  end

  private def map_blocks(fulldata : Array(Byte), &b)
    output = Array(Block).new
    fulldata.each_slice(BLOCK) do |block|
      output << yield block.blockvalue
    end
    output
  end

  private def generate_subkeys(masterkey : Array(Byte), rounds : Int32) : Array(HalfBlock)
    rounds.times.map { |i| masterkey.blockvalue.lshift(i).low }.to_a
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
