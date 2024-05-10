class Api::V1::VenuesController < Api::V1::ApiController
  def show
    venue = Venue.find(params[:id])
    render status: 200, json: venue.as_json(except: [:corporate_name, :registration_number, 
                                                     :user_id, :created_at, :updated_at],
                                            include: {events: {only: [:id, :venue_id, :name,
                                                                      :minimum_guests_number, 
                                                                      :maximum_guests_number]}})
  end

  def index
    venues = Venue.all 
    render status: 200, json: venues.as_json(except: [:corporate_name, :registration_number, 
                                                     :user_id, :created_at, :updated_at])
  end

  def search
    venues = Venue.where("brand_name LIKE ?", "%#{params[:q]}%")
    render status: 200, json: venues.as_json(except: [:corporate_name, :registration_number, 
                                                      :user_id, :created_at, :updated_at])
  end
end