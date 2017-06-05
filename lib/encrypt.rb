require 'bcrypt'
require 'digest/md5'

class Encrypt

  include BCrypt
  def initialize

  end

  def encrypt_bcrypt(to_encrypt)
    BCrypt::Password.create(to_encrypt)
  end

  def compare_bcrypt(string, hash)
    BCrypt::Password.new(hash) == to_encrypt
  end

  def encrypt_md5(to_encrypt)
    Digest::MD5.hexdigest(to_encrypt)
  end

  def compare_bcrypt(string, hash)
    hash == string
  end

end
