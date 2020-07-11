class ApplicationController < ActionController::Base
    protect_from_forgery
    helper_method :current_user

    def current_user
        @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
        auth_token = cookies.permanent[:auth_token]
        @current_user ||= User.find_by_authentication_token(auth_token) if auth_token
    end

    def require_authentication
        if current_user.nil?
            redirect_to :root, flash: { error: 'You must be logged in to access this page.' }
        end
    end

    def String.titlecase
        tmp = self.split(' ')
        tmp.each do |word|
            if word.length > 2
                word.capitalize!
            end
        end
        tmp.join(' ')
    end
end
