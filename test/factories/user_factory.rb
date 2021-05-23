FactoryBot.define do

  factory :user, class: User do
    handle_id { 'sean' }
    encrypted_password { EncryptionService.new.encrypt('local_password') }
    failed_login_count { 0 }
    is_locked { false }
  end

end
