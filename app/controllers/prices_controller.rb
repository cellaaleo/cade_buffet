class PricesController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    @price = Price.new
  end

  def create
    @event = Event.find(params[:event_id])
    @price = Price.new(price_params)
    @price.event = @event

    if @price.save
      redirect_to @event, notice: "Preços cadastrados com sucesso"
    else
      flash[:alert] = "Não foi possível cadastrar os preços"
      render 'new'
    end
    
  end
  
  private
  def price_params
    params.require(:price).permit(:weekday_base_price, 
                                  :weekday_plus_per_person,
                                  :weekday_plus_per_hour,
                                  :weekend_base_price,
                                  :weekend_plus_per_person,
                                  :weekend_plus_per_hour)
  end
end