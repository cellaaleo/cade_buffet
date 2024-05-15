class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @venue = Venue.find(params[:venue_id])
    @event = Event.new
  end

  def create
    @venue = Venue.find(params[:venue_id])
    @event = Event.new(event_params)
    @event.venue = @venue

    if @event.save 
      redirect_to @event, notice: 'Evento cadastrado com sucesso!'
    else
      flash.now[:alert] = 'Evento não cadastrado.'
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
    @price = @event.price
  end

  private
  def event_params
    params.require(:event).permit(:name, 
                                  :description, 
                                  :minimum_guests_number,
                                  :maximum_guests_number,
                                  :duration, 
                                  :menu, 
                                  :has_alcoholic_drinks, 
                                  :has_decorations, 
                                  :has_parking_service,
                                  :has_valet_service,
                                  :can_be_catering)
  end
end