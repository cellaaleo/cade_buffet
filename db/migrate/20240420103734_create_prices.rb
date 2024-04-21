class CreatePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.references :event, null: false, foreign_key: true
      t.integer :weekday_base_price
      t.integer :weekday_plus_per_person
      t.integer :weekday_plus_per_hour
      t.integer :weekend_base_price
      t.integer :weekend_plus_per_person
      t.integer :weekend_plus_per_hour

      t.timestamps
    end
  end
end
