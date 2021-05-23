require 'test_helper'

class EncryptionServiceTest < ActiveSupport::TestCase

  test 'encrypting and decrypting data works as expected' do
    password      = EncryptionService.new.encrypt('local_password')
    same_password = EncryptionService.new.encrypt('local_password')

    assert_not_equal password, same_password

    decrypted_one = EncryptionService.new.decrypt(password)
    decrypted_two = EncryptionService.new.decrypt(same_password)

    assert_equal decrypted_one, decrypted_two
  end

end
