# See documentation here for reference:
# https://api.rubyonrails.org/v5.2.4.4/classes/ActiveSupport/MessageEncryptor.html

class EncryptionService

  def initialize
    @crypt ||= generate_crypt
  end

  def encrypt(data)
    @crypt.encrypt_and_sign(data)
  end

  def decrypt(data)
    @crypt.decrypt_and_verify(data)
  end

  private

  def generate_crypt
    len        = ActiveSupport::MessageEncryptor.key_len
    salt       = ENV['ENCRYPTION_SALT'].present? ? ENV['ENCRYPTION_SALT'] : 'pvhJU\x9B\xE9\xE5.<\xA0\x9DVy\xE7\xAD\xFD\x150)\xF8\xDC\xD4\xE2D\xA3\xF9f\xAE\xBF\xE1\r'
    secret_key = ENV['SECRET_KEY'].present? ? ENV['SECRET_KEY'] : 'local_secret_only'
    key        = ActiveSupport::KeyGenerator.new(secret_key).generate_key(salt, len)

    ActiveSupport::MessageEncryptor.new(key)
  end

end
