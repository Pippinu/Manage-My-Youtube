
class ManagerController < ApplicationController

    before_action:require_user_logged_in!


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
    end

    def singleone
        @cliente= User.find(params[:cliente])
        if !Affiliation.where(manager: current_user.id).where(cliente: @cliente.id).where(status: 'accepted').take
            redirect_to ''
        end
    end

end