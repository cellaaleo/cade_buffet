class AddPaymentMethodToQuotation < ActiveRecord::Migration[7.1]
  def change
    add_column :quotations, :payment_method, :string
  end
end
