class OrdersController < ApplicationController
  before_action :authenticate_customer!

  def index
    @orders = current_customer.orders
  end
  
  def show
    @order = Order.find(params[:id])
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