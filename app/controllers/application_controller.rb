class ApplicationController < ActionController::Base
    
    def require_user_logged_in!
        redirect_to "/users/sign_in", alert: "Devi essere loggato !" if !current_user
    end
end
