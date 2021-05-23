require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def teardown
    super

    User.all.find_each do |user|
      user.destroy
    end
  end

  test 'validation on user works correctly' do
    user = User.new(handle_id: nil, encrypted_password: nil)

    assert_not user.valid?
    assert_not_empty user.errors[:handle_id]
    assert_not_empty user.errors[:encrypted_password]

    user.encrypted_password = '123'
    user.handle_id          = 'jack'
    assert user.save

    second_user = User.new(handle_id: 'jack', encrypted_password: '456')
    assert_not second_user.valid?

    second_user.handle_id = 'james'
    assert second_user.save
  end

end
