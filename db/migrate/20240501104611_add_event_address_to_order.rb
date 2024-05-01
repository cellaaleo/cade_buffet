class AddEventAddressToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :event_address, :string
  end
end
