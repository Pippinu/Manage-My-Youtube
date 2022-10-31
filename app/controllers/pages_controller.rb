class PagesController < ApplicationController
  def home
    if current_user 
      if !current_user.ruolo
        redirect_to '/users/edit' 
        flash.now[:notice] = 'Message sent!'
      end
    end
  end
end
