class SessionsController < ApplicationController

  def new; end

  def create
    user = User.find_by_handle_id(params[:handle_id])

    if user.present?
      result = AuthenticationService.new(user).validate_login(params[:password])

      if result.success?
        session[:user_id] = user.id
        redirect_to_root_with_message(t('views.sessions.create.success'))
      else
        render_failed_login_attempt(alert: result.error)
      end
    else
      render_failed_login_attempt
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to_root_with_message(t('views.sessions.destroy.success'))
  end

  private

  def create_params
    params.permit(:handle_id, :password)
  end

  def render_failed_login_attempt(alert: t('views.sessions.create.failure'))
    populate_form_errors
    flash.now[:alert] = alert

    respond_to do |format|
      format.html { render :new }
    end
  end

  def redirect_to_root_with_message(notice)
    flash[:notice] = notice

    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end

  def populate_form_errors
    errors = {}
    errors[:handle_id] = I18n.t('activerecord.errors.models.user.attributes.handle_id.presence') if params[:handle_id].blank?
    errors[:password] = I18n.t('activerecord.errors.models.user.attributes.password.presence') if params[:password].blank?

    @form = Form.new(errors)
  end

end
