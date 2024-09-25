class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: %i[new create confirmed canceled]
  before_action :authenticate_user!, only: %i[approved]
  before_action :set_order_and_check_customer_or_user, only: %i[show approved canceled confirmed]
  before_action :set_event_and_check_deactivation, only: %i[new create]

  def index
    if current_customer
      @orders = current_customer.orders
    elsif user_signed_in?
      return redirect_to new_venue_path unless current_user.venue

      @orders = current_user.venue.orders
    end
  end

  def show
    return unless current_user

    @same_date_orders = []
    orders = current_user.venue.orders.where.not(status: :canceled)

    orders.each do |ord|
      @same_date_orders << ord if ord.code != @order.code && ord.event_date == @order.event_date
    end
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.event = @event
    @order.venue = @event.venue
    @order.customer = current_customer

    unless @order.save
      flash.now[:alert] = t('alerts.order.not_created')
      return render :new, status: :unprocessable_entity
    end

    redirect_to @order, notice: t('notices.order.created')
  end

  def approved
    @order.approved!
    redirect_to @order, notice: t('notices.order.approved')
  end

  def confirmed
    @order.confirmed!
    redirect_to @order, notice: t('notices.order.confirmed')
  end

  def canceled
    @order.canceled!
    redirect_to @order, notice: t('notices.order.canceled')
  end

  private

  def order_params
    params.require(:order).permit(:event_date, :number_of_guests, :event_details, :event_address)
  end

  def set_order_and_check_customer_or_user
    @order = Order.find(params[:id])
    if (current_customer && @order.customer != current_customer) || (current_user && @order.venue != current_user.venue)
      redirect_to root_path, alert: 'Você não tem acesso a este pedido'
    end
  end

  def set_event_and_check_deactivation
    @event = Event.find(params[:event_id])
    return unless @event.inactive? || @event.venue.inactive?

    redirect_to root_path, alert: t('alerts.order.access_denied')
  end
end
