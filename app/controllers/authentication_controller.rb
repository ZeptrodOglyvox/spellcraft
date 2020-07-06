class AuthenticationController < ApplicationController
  before_action :require_authentication, only: [:account_settings, :set_account_info]

  def sign_in 
    @user = User.new
  end

  def login
    id = params[:user][:username]
    password = params[:user][:password]
    if id =~ /.+@.+\..+/ # TODO: not good enough
      @user = User.authenticate_by_email(id, password)
    else  
      @user = User.authenticate_by_username(id, password)
    end

    if @user
      session[:user_id] = @user.id
      update_authentication_token(@user, params[:remember_me])
      @user.last_sign_in = DateTime.now 
      @user.save(validate: false)
      redirect_to :root, notice: 'Sign in successful.'
    else
      flash.now[:error] = 'Invalid login credentials.'
      render :sign_in
    end
  end

  def signed_out
    update_authentication_token(current_user, nil) if current_user
    session[:user_id] = nil 
    flash[:notice] = 'You have been signed out.'
    redirect_to :root
  end

  def new_user
    @user = User.new
  end

  def register
    @user = User.new 

    if verify_recaptcha()
      @user.assign_attributes(user_params)
      @user.signed_up_on = DateTime.now
      @user.last_sign_in = @user.signed_up_on

      if @user.save 
        # UserMailer.with(user: @user).welcome_email.deliver_later
        redirect_to :sign_in, notice: 'Registration successful, you can now sign in with your credentials.'
      else
        render :new_user
      end
    else
      flash.delete(:recaptcha_error)
      flash.now[:error] = 'reCAPTCHA verification failed, please try again.'
      render action: 'new_user'
    end
  end

  def account_settings
    # TODO what if none?
    @user = current_user
  end

  def set_account_info
    @user = User.authenticate_by_username(current_user.username, params[:current_password])

    if @user.nil?
      @user = current_user
      @user.errors.messages[:password] = 'Please type your current password correctly.'
      render 'account_settings'
    else
      @user.assign_attributes(update_params)

      if @user.valid? 
        @user.save 
        redirect_to :root, notice: 'Information updated successfully.'
      else
        render 'account_settings'
      end
    end
  end

  def destroy_user
    username = params[:username]
    @user = User.find_by_username(username)

    if not @user.nil?
      @user.destroy 
      if current_user and username == current_user.username
        redirect_to 'signed_out'
      else
        redirect_to :root, notice: "User #{username} has been deleted from the database."
      end
    else
      redirect_to :root, notice: "User #{username} doesn't exist."
    end
  end

  def forgot_password
    @user = User.new
  end

  def send_password_reset_instructions
    id = params[:user][:username]

    if id =~ /.+@.+\..+/
      user = User.find_by_email(id)
    else
      user = User.find_by_username(id)
    end
    
    if user.nil?
      @user = User.new
      flash.now[:error] = 'We could not find the username/email.'
      render 'forgot_password'
    else
      user.password_reset_token = SecureRandom.urlsafe_base64
      user.token_expires_after = 24.hours.from_now

      user.save(validate: false) # TODO Think about this more

      UserMailer.with(user: user).reset_password_email.deliver_later
      redirect_to :sign_in, notice: ' Password reset instructions have been sent to your email.'
    end
  end

  def password_reset
    @user = User.find_by(password_reset_token: params[:token])
    if @user.nil?
      redirect_to :root, flash: { error: 'The password reset link you are used is invalid.' }
    elsif @user.token_expires_after < DateTime.now
      clear_password_reset(@user)
      redirect_to :root, flash: { error: 'The password reset link has expired, please request a new one.' }
    end
  end

  def new_password 
    reset_params = params.require(:user).permit(:password, :password_confirmation)
    @user = User.find_by_username(params[:user][:username]) # Does this work? Why?

    if @user.update(reset_params)
      clear_password_reset(@user)
      redirect_to :sign_in, notice: 'Password updated successfully.'
    else
      # TODO: If we used a _tag form this wouldn't be necessary...
      @user.password = ''
      @user.password_confirmation = ''
      render :password_reset
    end
  end

  private

  def login_params
    # kind of useless for now
    params.require(:user).permit(:username, :password)
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def update_params
    values = params.require(:user) \
      .reject! { |key, value| value.nil? or value.blank? } \
      .permit(:username, :email, :password, :password_confirmation)
      
    values[:password] ||= params[:current_password]  # TODO ew, do better
    values[:password_confirmation] ||= params[:current_password]  # TODO ew, do better
    values
  end

  def clear_password_reset(user)
    user.password_reset_token = nil
    user.token_expires_after = nil
    user.save(validate: false)
  end

  def update_authentication_token(user, remember_me)
    if remember_me == "1"
      auth_token = SecureRandom.urlsafe_base64
      user.authentication_token = auth_token
      user.save(validate: false)
      cookies.permanent[:auth_token] = auth_token
    else
      user.authentication_token = nil
      cookies.permanent[:auth_token] = nil
    end
  end
end