require "test_helper"

class ProductTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  context "validations" do
    subject { FactoryBot.build(:product) }

    should validate_presence_of(:name)
    should validate_numericality_of(:price).is_greater_than_or_equal_to(0)
    should validate_numericality_of(:inventory_count).is_greater_than_or_equal_to(0)
  end

end
