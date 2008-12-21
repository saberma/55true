require 'openssl' 

module DES
  @@key = "we love 55true"
  @@iv = "and me too"

  def self.encrypt(data)
    des = OpenSSL::Cipher::Cipher.new("des-ecb")
    des.encrypt
    des.key,des.iv = @@key,@@iv
    encrypted_content = des.update(data) << des.final
    Base64.encode64(encrypted_content)
  end

  def self.decrypt(crypted_data)
    encrypted_content = Base64.decode64(crypted_data)
    des = OpenSSL::Cipher::Cipher.new("des-ecb")
    des.decrypt
    des.key,des.iv = @@key,@@iv
    des.update(encrypted_content) << des.final
  end
end