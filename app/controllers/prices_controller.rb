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

    unless @price.save
      flash.now[:alert] = t('alerts.price.not_created')
      return render :new, status: :unprocessable_entity
    end

    redirect_to @event, notice: t('notices.price.created')
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
