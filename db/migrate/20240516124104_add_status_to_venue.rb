class AddStatusToVenue < ActiveRecord::Migration[7.1]
  def change
    add_column :venues, :status, :integer, default: 0
  end
end
