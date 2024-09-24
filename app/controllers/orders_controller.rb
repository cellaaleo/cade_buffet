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

    if @order.save
      redirect_to @order, notice: 'Pedido registrado com sucesso!'
    else
      flash.now[:alert] = 'Não foi possível registrar o pedido.'
      render :new
    end
  end

  def approved
    @order.approved!
    redirect_to @order
  end

  def confirmed
    @order.confirmed!
    redirect_to @order
  end

  def canceled
    @order.canceled!
    redirect_to @order
  end

  private

  def order_params
    params.require(:order).permit(:event_date, :number_of_guests, :event_details, :event_address)
  end

  def set_order_and_check_customer_or_user
    @order = Order.find(params[:id])
    if current_customer
      redirect_to root_path, alert: 'Você não tem acesso a este pedido' if @order.customer != current_customer
    elsif current_user
      redirect_to root_path, alert: 'Você não tem acesso a este pedido' if @order.venue != current_user.venue
    end
  end

  def set_event_and_check_deactivation
    @event = Event.find(params[:event_id])
    if @event.inactive?
      redirect_to root_path, alert: 'Não foi possível acessar cadastro de pedido. Evento inativado pelo buffet!'
    elsif @event.venue.inactive?
      redirect_to root_path, alert: 'Não foi possível acessar cadastro de pedido. Buffet inativo!'
    end
  end
end
