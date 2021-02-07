class CreateWarehouses < ActiveRecord::Migration[5.2]
  def change
    create_table :warehouses do |t|
      t.string :name, null: false
      t.text :address, null: false
      t.float :balance, null: false, default: 0

      t.timestamps
    end

    add_index :warehouses, :name, unique: true
    add_index :warehouses, :address, unique: true
  end
end
