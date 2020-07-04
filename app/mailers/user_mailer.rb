class UserMailer < ApplicationMailer
    default from: 'notifications@example.com'

    def welcome_email
        @user = params[:user]
        @url = 'localhost:3000/sign_in'
        mail(to: @user.email, subject: 'Welcome to Spellcraft.')
    end
end
