class YtMenuController < ApplicationController
  def index
  end

=begin   private
=end
=begin def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end 
=end

=begin helper_method :current_user 
=end
end
