class PagesController < ApplicationController
  
  def home
    
    if current_user 
      if !current_user.ruolo
        redirect_to '/users/edit' and return
        flash.now[:notice] = 'Message sent!'
      end
    end
    render :layout => 'home'
  end
end
