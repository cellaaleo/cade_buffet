class AddIndexToCustomer < ActiveRecord::Migration[7.1]
  def change
    #add_column :customers, :cpf, :string
    add_index :customers, :cpf, unique: true
  end
end
