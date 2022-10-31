
class ManagerController < ApplicationController

    before_action:require_user_logged_in!
    before_action:are_you_a_manager

    def index
        @users=User.all
    end

    def affiliazioni
        @affiliazioni=Affiliation.all
    end

    def aziende
        @users=User.all
        @cliente= params[:id]
        @manager= current_user.id
        is_it_your_client(@manager,@cliente)
    end

    def singleone
        @cliente= User.find(params[:cliente])
        is_it_your_client(current_user.id,@cliente.id)
    end

    def events
        @cliente= User.find(params[:cliente])
        @events=Event.all
        is_it_your_client(current_user.id,@cliente.id)
    end

end