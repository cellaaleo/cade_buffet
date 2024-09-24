class EventsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create active inactive deactivated]
  before_action :check_user_and_set_event, only: %i[active inactive]

  def show
    @event = Event.find(params[:id])
    @price = @event.price
  end

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

  def active
    @event.active!
    redirect_to @event, notice: 'Evento reativado com sucesso.'
  end

  def inactive
    @event.inactive!
    redirect_to @event, notice: 'Evento desativado com sucesso.'
  end

  def deactivated
    @venue = Venue.find(params[:venue_id])
    @events = @venue.events.inactive
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :minimum_guests_number, :maximum_guests_number,
                                  :duration, :menu, :has_alcoholic_drinks, :has_decorations,
                                  :has_parking_service, :has_valet_service, :can_be_catering)
  end

  def check_user_and_set_event
    @event = Event.find(params[:id])
    redirect_to venue_path(current_user.venue.id) if @event.venue != current_user.venue
  end
end
