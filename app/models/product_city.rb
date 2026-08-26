class ProductCity < ApplicationRecord
  belongs_to :product
  belongs_to :city

  validates :city_id, uniqueness: { scope: :product_id }

end
