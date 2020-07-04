class AuthenticationController < ApplicationController
  def sign_in 
    @user = User.new
  end

  def login
    id = params[:user][:username]
    password = params[:user][:password]
    if id[/@/] # TODO: not good enough
      user = User.authenticate_by_email(id, password)
    else  
      user = User.authenticate_by_username(id, password)
    end

    if user
      session[:user_id] = user.id
      redirect_to :root, notice: 'Sign in successful.'
    else
      flash.now[:error] = 'Invalid login credentials.'
      render 'sign_in'
    end
  end

  def signed_out
    session[:user_id] = nil 
    flash[:notice] = 'You have been signed out.'
    redirect_to :root
  end

  def new_user
    @user = User.new
  end

  def register
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user_id
      UserMailer.with(user: @user).welcome_email.deliver_now

      redirect_to :root, notice: 'Registration Successful'
    else     
      # Errors will be shown with a helper function
      puts ("\n" + @user.errors.inspect + "\n")
      render :new_user
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

  private

  def login_params
    # kind of useless for now
    params.require(:user).permit(:username, :password)
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def update_params
    values = params.require(:user).reject! { |key, value| value.nil? or value.blank? }

    if not values.has_key?(:password)
      values[:password] = params[:current_password]  # TODO ew, do better
      values[:password_confirmation] = params[:current_password]  # TODO ew, do better
    end

    values.permit(:username, :email, :password, :password_confirmation)
  end
end
