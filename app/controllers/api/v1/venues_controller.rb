class Api::V1::VenuesController < Api::V1::ApiController
  def index
    venues = Venue.all
    venues = venues.active
    render status: :ok, json: venues.as_json(except: %i[corporate_name registration_number
                                                        user_id created_at updated_at])
  end

  def show
    venue = Venue.find(params[:id])
    if venue.active?
      render status: :ok, json: venue.as_json(except: %i[corporate_name registration_number
                                                         user_id created_at updated_at],
                                              include: { events: { except: %i[created_at updated_at] } })
    else
      render status: :forbidden, json: { error: 'Não foi possível acessar este conteúdo' }
    end
  end

  def search
    venues = Venue.where('brand_name LIKE ?', "%#{params[:venue]}%")
    venues = venues.active
    render status: :ok, json: venues.as_json(except: %i[corporate_name registration_number
                                                        user_id created_at updated_at])
  end
end
