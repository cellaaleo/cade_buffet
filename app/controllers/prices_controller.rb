class PricesController < ApplicationController
  def new
    @price = Price.new
    @events = Event.all
  end

  def create
    @price = Price.new(prices_params)
    @price.save
    flash[:notice] = "Preços cadastrados com sucesso"
    redirect_to event_path(@price.event_id)
  end

  
  private
  def prices_params
    params.require(:price).permit(:weekday_base_price, 
                                  :weekday_plus_per_person,
                                  :weekday_plus_per_hour,
                                  :weekend_base_price,
                                  :weekend_plus_per_person,
                                  :weekend_plus_per_hour,
                                  :event_id)
  end
end