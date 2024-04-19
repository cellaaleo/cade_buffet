class ApplicationController < ActionController::Base
  
  protected

  def after_sign_in_path_for(resource) 

    if current_user.buffet_owner
      if current_user.venue
        venue_path(current_user.venue.id)
      else
        new_venue_path
      end
    end

  end

end
