class AddIndexToVenues < ActiveRecord::Migration[7.1]
  def change
    #add_column :venues, :registration_number, :string
    add_index :venues, :registration_number, unique: true
  end
end
