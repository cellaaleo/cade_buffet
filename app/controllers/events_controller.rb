class EventsController < ApplicationController
  
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.venue = current_user.venue

    @event.save
    redirect_to @event, notice: 'Evento cadastrado com sucesso!'
  end

  def show
    @event = Event.find(params[:id])
    @price = @event.price
  end

  def index
    @events =  Event.all
  end

  private
  def event_params
    params.require(:event).permit(:name, 
                                  :description, 
                                  :minimum_guests_number,
                                  :maximun_guests_number,
                                  :duration, 
                                  :menu, 
                                  :has_alcoholic_drinks, 
                                  :has_decorations, 
                                  :has_parking_service,
                                  :has_valet_service,
                                  :can_be_catering)
  end
end