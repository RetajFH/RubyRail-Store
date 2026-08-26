class Product < ApplicationRecord
  include Notifications

  has_one_attached :featured_image
  has_rich_text :description

  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true
  validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }
  serialize :sizes, coder: JSON
  


  scope :price_gteq, ->(price) {
    where("price >= ?", price)
  }

  scope :price_lteq, ->(price) {
    where("price  <= ?",price)
  }

  scope :search_by_name, ->(name) {
    where("name LIKE ?", "%#{name}%")
  }

  before_validation :convert_sizes_to_array

  private
  def convert_sizes_to_array
    return unless sizes.is_a?(String)
    self.sizes = sizes.split(",").map(&:strip).reject(&:blank?)
  end
end
