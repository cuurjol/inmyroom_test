class Product < ApplicationRecord
  belongs_to :warehouse

  validates :name, presence: true, uniqueness: { scope: :warehouse_id }
  validates :price, :quantity, presence: true, numericality: { greater_than: 0 }
end
