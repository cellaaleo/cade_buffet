class Api::V1::VenuesController < Api::V1::ApiController
  def show
    venue = Venue.find(params[:id])
    render status: 200, json: venue.as_json(except: [:corporate_name, :registration_number, 
                                                     :user_id, :created_at, :updated_at],
                                            include: {events: {except: [:created_at, :updated_at]}})
  end

  def index
    venues = Venue.all 
    render status: 200, json: venues.as_json(except: [:corporate_name, :registration_number, 
                                                     :user_id, :created_at, :updated_at])
  end

  def search
    venues = Venue.where("brand_name LIKE ?", "%#{params[:venue]}%")
    render status: 200, json: venues.as_json(except: [:corporate_name, :registration_number, 
                                                      :user_id, :created_at, :updated_at])
  end
end