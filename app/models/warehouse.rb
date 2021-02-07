class Warehouse < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, :address, presence: true, uniqueness: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
