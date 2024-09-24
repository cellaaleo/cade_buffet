class QuotationsController < ApplicationController
  def new
    @order = Order.find(params[:order_id])
    @quotation = Quotation.new
  end

  def create
    @order = Order.find(params[:order_id])
    @quotation = Quotation.new(quotation_params)
    @quotation.order = @order

    if @quotation.save
      redirect_to @order, notice: 'Orçamento registrado com sucesso!'
    else
      flash[:alert] = 'Não foi possível enviar o orçamento!'
      render 'new'
    end
  end

  private

  def quotation_params
    params.require(:quotation).permit(:discount_or_extra_fee,
                                      :discount_or_extra_fee_description,
                                      :expiry_date,
                                      :payment_method)
  end
end
