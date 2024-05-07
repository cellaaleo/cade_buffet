class RemoveMaximunGuestsNumberFromEvents < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :maximun_guests_number, :integer
  end
end
