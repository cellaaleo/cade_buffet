class HomeController < ApplicationController
  def index
    @venues = Venue.all
    @venues = @venues.active

    return unless user_signed_in?

    return redirect_to venue_path(current_user.venue.id) if current_user.venue

    redirect_to new_venue_path
  end

  def select_login_type; end

  def select_sign_up_type; end
end
