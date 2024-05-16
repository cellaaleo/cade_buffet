class Api::V1::VenuesController < Api::V1::ApiController
  def show
    venue = Venue.find(params[:id])
    if venue.active?
      render status: 200, json: venue.as_json(except: [:corporate_name, :registration_number, 
                                                     :user_id, :created_at, :updated_at],
                                            include: {events: {except: [:created_at, :updated_at]}})
    else 
      render status: 403, json: {error: 'Não foi possível acessar este conteúdo'}
    end
  end

  def index
    venues = Venue.all 
    venues = venues.active
    render status: 200, json: venues.as_json(except: [:corporate_name, :registration_number, 
                                                     :user_id, :created_at, :updated_at])
  end

  def search
    venues = Venue.where("brand_name LIKE ?", "%#{params[:venue]}%")
    venues = venues.active
    render status: 200, json: venues.as_json(except: [:corporate_name, :registration_number, 
                                                      :user_id, :created_at, :updated_at])
  end
end