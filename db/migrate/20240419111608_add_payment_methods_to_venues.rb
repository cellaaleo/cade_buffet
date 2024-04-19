class AddPaymentMethodsToVenues < ActiveRecord::Migration[7.1]
  def change
    add_column :venues, :payment_methods, :text
  end
end
