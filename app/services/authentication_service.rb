class AuthenticationService

  MAX_LOGIN_ATTEMPTS_ALLOWED = 3

  def initialize(user)
    @user = user
  end

  def validate_login(password)
    return ServiceError.new(@user, "Your account is now locked following #{MAX_LOGIN_ATTEMPTS_ALLOWED} failed login attempts.") if @user.is_locked?

    if password == EncryptionService.new.decrypt(@user.encrypted_password)
      process_successful_login

      ServiceSuccess.new(@user)
    else
      process_failed_login

      if @user.is_locked?
        ServiceError.new(@user, "Your account is now locked following #{MAX_LOGIN_ATTEMPTS_ALLOWED} failed login attempts.")
      else
        ServiceError.new(@user, "The details you entered are not correct. Your account will be locked in #{MAX_LOGIN_ATTEMPTS_ALLOWED - @user.failed_login_count} more failed attempt(s).")
      end
    end
  end

  private

  def process_successful_login
    @user.failed_login_count = 0
    @user.save
  end

  def process_failed_login
    @user.failed_login_count += 1

    if @user.failed_login_count >= MAX_LOGIN_ATTEMPTS_ALLOWED
      @user.is_locked = true
    end

    @user.save
  end

end
