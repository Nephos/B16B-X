require "./spec_helper"

include B16B5

describe B16B5 do
  it "works" do
    fulldata = "01234567".bytes
    key = "abcd"[0...B16B5::BLOCK].bytes

    encrypteddata = feistel_encrypt(fulldata, key, 8)
    decrypteddata = feistel_decrypt(encrypteddata, key, 8)
    (encrypteddata == decrypteddata).should eq false
    (decrypteddata == fulldata).should eq true
  end
end
