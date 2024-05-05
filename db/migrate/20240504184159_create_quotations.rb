class CreateQuotations < ActiveRecord::Migration[7.1]
  def change
    create_table :quotations do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :discount_or_extra_fee
      t.string :discount_or_extra_fee_description
      t.date :expiry_date

      t.timestamps
    end
  end
end
