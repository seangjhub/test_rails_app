require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    super
    @user = User.find_by_handle_id('sean') || FactoryBot.create(:user)
  end

  test 'new action renders login form or logout link based on session authentication' do
    get new_sessions_path
    assert_response :success

    assert_nil session[:user_id]
    assert_select '#user-form'

    assert_successful_login

    assert_equal @user.id, session[:user_id]
    assert_select 'a[href=?]', sessions_path
  end

  test 'create action successfully authenticates user' do
    assert_successful_login
  end

  test 'create action renders form errors correctly' do
    post sessions_path, params: {handle_id: '', password: ''}
    assert_response :success

    assert_select '.invalid-feedback', 'You need to submit a value for your Username/Email.'
    assert_select '.invalid-feedback', 'You need to submit a value for Password.'
  end

  test 'users account is locked when reaching maximum number of failed login attempts and cannot login until manually unlocked' do
    2.times do
      assert_failed_login
    end

    @user.reload
    assert_not @user.is_locked?
    assert_equal 2, @user.failed_login_count

    # assert login clears failed count when user is not locked

    assert_successful_login
    assert_login_clears_failed_count

    3.times do
      assert_failed_login
    end

    @user.reload
    assert @user.is_locked?
    assert_equal 3, @user.failed_login_count

    # now enter in correct password and confirm that user cannot login

    post sessions_path, params: {handle_id: @user.handle_id, password: EncryptionService.new.decrypt(@user.encrypted_password)}

    assert_response :success
    assert_select '.alert-notice', 'Your account is now locked following 3 failed login attempts.'

    # unlock account manually and assert that user can login again

    @user.is_locked = false
    assert @user.save

    assert_successful_login
    assert_login_clears_failed_count
  end

  private

  def assert_successful_login
    post sessions_path, params: {handle_id: @user.handle_id, password: EncryptionService.new.decrypt(@user.encrypted_password)}

    assert_redirected_to root_path
    follow_redirect!

    assert_response :success
  end

  def assert_failed_login
    post sessions_path, params: {handle_id: @user.handle_id, password: 'wrong_password'}
    assert_response :success
  end

  def assert_login_clears_failed_count
    @user.reload
    assert_not @user.is_locked?
    assert_equal 0, @user.failed_login_count
  end
end
