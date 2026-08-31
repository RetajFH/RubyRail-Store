class City < ApplicationRecord
  has_many :product_cities, dependent: :destroy
  has_many :products, through: :product_cities

  validates :name, presence: true, uniqueness: true
end
