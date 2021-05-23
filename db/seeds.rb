# Create User Account
user = User.create(handle_id: 'sean', encrypted_password: EncryptionService.new.encrypt('local_password'))
