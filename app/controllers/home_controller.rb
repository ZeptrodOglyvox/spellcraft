class HomeController < ApplicationController
    def test
        if false # or true
            render :test 
        else
            flash.now[:error] = "message"
            render 'authentication/sign_in'
        end
    end
end
