class RemoveEventAdressFromOrder < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :event_adress, :string
  end
end
