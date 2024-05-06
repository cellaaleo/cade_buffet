class QuotationsController < ApplicationController

  def new
    @order = Order.find(params[:order_id])
    @quotation = Quotation.new
  end

  def create
    @order = Order.find(params[:order_id])
    @order.create_quotation!(quotation_params)
    redirect_to @order, notice: 'Orçamento registrado com sucesso!'
  end

  private
  def quotation_params
    params.require(:quotation).permit(:discount_or_extra_fee,
                                      :discount_or_extra_fee_description,
                                      :expiry_date,
                                      :payment_method)
  end
end