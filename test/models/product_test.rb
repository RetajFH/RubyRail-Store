require "test_helper"

class ProductTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  seetup do 
    @product = products(:tshirt)
    @product.update(inventory_count: 0)
  end

  test "is invalid without a name" do
    @product.name = nil
    assert_not @product.valid?
    assert_includes @product.errors[:name], "can't be blank"
  end

  test "is invalid with a negative price" do
    @product.price = -5
    assert_not @product.valid?
  end

  test "sends email notifications when back in stock" do
    assert_emails 2 do
      @product.update(inventory_count: 99)
    end
  end

  test "dont sends email notifications when nventory count equal to 0 and positive" do
    assertـno_emails("subscribers")do
      @product.update(inventory_count: 0)
    end
  end

end
