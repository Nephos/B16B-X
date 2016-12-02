require "./spec_helper"

include B16B5

describe B16B5 do
  it "works" do
    data = "012345678".bytes
    fulldata = data + Array.new((B16B5::BLOCK - data.size) % B16B5::BLOCK) { 0_u8 }

    key = "abcd"[0...B16B5::BLOCK].bytes
    key = KEY # .blockvalue

    encrypteddata = feistel_encrypt(fulldata, key)
    decrypteddata = feistel_decrypt(encrypteddata, key)
    (encrypteddata == decrypteddata).should eq false
    (decrypteddata == fulldata).should eq true
  end
end
