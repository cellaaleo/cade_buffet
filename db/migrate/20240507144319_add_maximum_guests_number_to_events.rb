class AddMaximumGuestsNumberToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :maximum_guests_number, :integer
  end
end
