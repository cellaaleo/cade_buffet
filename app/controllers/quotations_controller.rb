class QuotationsController < ApplicationController
  def new
    @order = Order.find(params[:order_id])
    @quotation = Quotation.new
  end

  def create
    @order = Order.find(params[:order_id])
    @quotation = Quotation.new(quotation_params)
    @quotation.order = @order

    unless @quotation.save
      flash.now[:alert] = t('alerts.quotation.not_created')
      return render :new, status: :unprocessable_entity
    end

    redirect_to @order, notice: t('notices.quotation.created')
  end

  private

  def quotation_params
    params.require(:quotation).permit(:discount_or_extra_fee,
                                      :discount_or_extra_fee_description,
                                      :expiry_date,
                                      :payment_method)
  end
end
