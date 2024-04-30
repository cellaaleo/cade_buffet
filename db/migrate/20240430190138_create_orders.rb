class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.date :event_date
      t.integer :number_of_guests
      t.string :event_details
      t.string :event_adress
      t.string :code
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
