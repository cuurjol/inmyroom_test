class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :quantity, null: false
      t.float :price, null: false
      t.references :warehouse, null: false, foreign_key: true

      t.timestamps
    end

    add_index :products, %i[name warehouse_id], unique: true
  end
end
