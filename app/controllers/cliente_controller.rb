
class ClienteController < ApplicationController

    before_action:require_user_logged_in!
    before_action:are_you_a_client

    def search
        @users = User.all
    end

    def function
    end

    def visualize
        @profilatoId= params[:id]
        @profilato = User.find(params[:id])
        is_it_a_manager(@profilato)
    end

    def events
        @events=Event.all
    end

end