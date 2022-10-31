class AziendaController < ApplicationController

    def index
        @users = User.all
    end

    def affiliazioni
        @affiliazioni= Affiliation.all
    end
  
  end
  