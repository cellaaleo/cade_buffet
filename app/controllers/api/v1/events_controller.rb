class Api::V1::EventsController < Api::V1::ApiController
  def index
    venue = Venue.find(params[:venue_id])
    events = Event.where(["venue_id LIKE '%?'", venue.id])
    render status: 200, json: events.as_json(only: [:id, :venue_id, :name,
                                                    :minimum_guests_number, 
                                                    :maximum_guests_number])
  end
end