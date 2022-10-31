
class UtilityController < ApplicationController

    def annulla
        affiliation= Affiliation.find(params[:id])
        @cliente= affiliation.cliente
        @manager= affiliation.manager
        @azienda= affiliation.azienda
        affiliation.destroy
        if current_user.ruolo=="cliente"
            redirect_to("/cliente/managerprofile?id="+@manager)
        end
        if current_user.ruolo=="manager"
            redirect_to("/manager/aziende?id="+@cliente)
        end
    end

end