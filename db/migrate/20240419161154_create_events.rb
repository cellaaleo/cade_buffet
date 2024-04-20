class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.references :venue, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.integer :minimum_guests_number
      t.integer :maximun_guests_number
      t.integer :duration
      t.text :menu
      t.boolean :has_alcoholic_drinks
      t.boolean :has_decorations
      t.boolean :has_parking_service
      t.boolean :has_valet_service
      t.boolean :can_be_catering

      t.timestamps
    end
  end
end
