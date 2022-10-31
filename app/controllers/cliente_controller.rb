
class ClienteController < ApplicationController

    before_action:require_user_logged_in!

    def search
        @users = User.all
    end

    def function
    end

    def visualize
        @profilatoId= params[:id]
        @profilato = User.find(params[:id])
    end

end