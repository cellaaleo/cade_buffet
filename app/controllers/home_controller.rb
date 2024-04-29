class HomeController < ApplicationController
  def index
    @venues = Venue.all

    if current_user
      if current_user.venue
        return redirect_to venue_path(current_user.venue.id)
      else
        return redirect_to new_venue_path
      end
      
    end
  end

  def select_login_type
  end

  def select_sign_up_type
  end
end