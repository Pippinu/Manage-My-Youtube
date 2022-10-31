class AziendaController < ApplicationController

    before_action:require_user_logged_in!
    before_action:are_you_an_azienda

    def index
        @users = User.all
    end

    def affiliazioni
        @affiliazioni= Affiliation.all
    end
  
  end
  