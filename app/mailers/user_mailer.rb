class UserMailer < ApplicationMailer
    default from: 'info@spellcraft.com'

    def welcome_email
        @user = params[:user]
        @url = 'localhost:3000/sign_in'
        mail(to: @user.email, subject: 'Welcome to Spellcraft.')
    end

    def reset_password_email
        @user = params[:user] 
        @password_reset_url = 'localhost:3000/password_reset?token=' + @user.password_reset_token
        mail(to: @user.email, subject:'Password Reset Instructions.')
    end
end
