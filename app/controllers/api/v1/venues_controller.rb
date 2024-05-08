class Api::V1::VenuesController < ActionController::API
  def show
    venue = Venue.find(params[:id])
    render status: 200, json: venue.as_json(except: [:corporate_name, :registration_number, 
                                                     :user_id, :created_at, :updated_at])
  end

  def index
    venues = Venue.all 
    render status: 200, json: venues
  end
end