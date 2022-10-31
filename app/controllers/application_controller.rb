class ApplicationController < ActionController::Base
    
    #Sei loggato ?
    def require_user_logged_in!
        redirect_to "/users/sign_in", alert: "Devi essere loggato !" if !current_user
    end

    #CLIENTE CHECKS

    def is_it_a_manager(manager_to_check)
        if manager_to_check.ruolo!='manager'
            redirect_to '', alert: 'Non è un manager !'
        end
    end

    def are_you_a_client
        if (current_user.ruolo && current_user.ruolo!="cliente")
            redirect_to '',alert: 'Non sei un liente !'
        end
    end

    #MANAGER CHECKs

    def is_it_a_cliente(cliente_to_check)
        if cliente_to_check.ruolo!='cliente'
            redirect_to '', alert: 'Non è un cliente !'
        end
    end

    def is_it_your_client(manager,cliente)
        if !Affiliation.where(manager: manager).where(cliente: cliente).where(status: 'accepted').take
            redirect_to '',alert: 'Non è un tuo cliente !'
        end
    end

    def are_you_a_manager
        if (current_user.ruolo && current_user.ruolo!="manager")
            redirect_to '',alert: 'Non sei un manager !'
        end
    end

    #AZIENDA CHECKs

    def are_you_an_azienda
        if (current_user.ruolo && current_user.ruolo!="azienda")
            redirect_to '',alert: "Non sei un'azienda !"
        end
    end

end
