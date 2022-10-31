
class UtilityController < ApplicationController

    def annulla
        affiliation= Affiliation.find(params[:id])
        @cliente= affiliation.cliente
        @manager= affiliation.manager
        @azienda= affiliation.azienda

        #ELIMINA TUTTE LE AFFILIAZIONI RELATIVE A QUEL MANAGER E A QUEL CLIENTE SE STO ELIMINANDO L'AFFILIAZIONE MANAGER-CLIENTE
        if @azienda==""
            affiliazioni= Affiliation.all
            calendari= Calendar.all
            eventi= Event.all

            affiliazioni.each do |affiliazione_like|
                if (affiliazione_like.cliente==@cliente && affiliazione_like.manager==@manager)
                    affiliazione_like.destroy
                end
            end
            
            #ELIMINA I LORO CALENDARI DAL DATABASE
            calendari.each do |calendario|
                if (calendario.userId.to_i==@cliente.to_i && calendario.managerId.to_i==@manager.to_i)
                    calendario.destroy
                    redirect_to '/calendar/deleteCalendar?userID='+@cliente and return
                end
            end

            #ELIMINA I LORO EVENTI DAL DATABASE
            eventi.each do |evento|
                if (evento.clienteID.to_i==@cliente.to_i && evento.managerID.to_i==@manager.to_i)
                    evento.destroy
                end
            end

            if current_user.ruolo=='cliente' 
                redirect_to("/cliente/managerprofile?id="+@manager)
            else 
                redirect_to("/manager")
            end

        #ALTRIMENTI ELIMINA SOLO L'AFFILIAZIONE MANAGER-AZIENDA
        else 
            affiliation.destroy
            redirect_to("/manager/aziende?id="+@cliente)
        end
    end

end