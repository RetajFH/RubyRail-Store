class Product < ApplicationRecord
  include Notifications

  has_one_attached :featured_image
  has_rich_text :description

  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true
  validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }

  serialize :sizes, coder: JSON
   

  scope :price_gteq, ->(price) {price.present? ? where("price >= ?", price) : all}
  scope :price_lteq, ->(price) {price.present? ? where("price <= ?", price) : all}


  before_validation :split_sizes

  private
  def split_sizes
    return unless sizes.is_a?(String)
    self.sizes = sizes.split(",").map(&:strip).reject(&:blank?)
  end
end
