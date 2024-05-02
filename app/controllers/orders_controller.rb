class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :create]

  def index
    if current_customer
      @orders = current_customer.orders
    elsif current_user
      @orders = current_user.venue.orders
    end
  end
  
  def show
    if current_customer
      @order = Order.find(params[:id])
    elsif current_user
      @order = Order.find(params[:id])
      @same_date_orders = []

      orders = current_user.venue.orders
      orders.each do |ord|
        unless ord.status == 'canceled'
          if ord.code != @order.code && ord.event_date == @order.event_date
            @same_date_orders << ord
          end
        end
      end
    end
  end

  def new
    @event = Event.find(params[:event_id])
    @order = Order.new
  end
  
  def create
    @event = Event.find(params[:event_id])
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
  

  private
  def order_params
    params.require(:order).permit(:event_date, :number_of_guests, :event_details, :event_address)
  end
end