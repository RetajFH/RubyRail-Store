require "test_helper"

class NotificationsChannelTest < ActionCable::Channel::TestCase
  include ActiveCable::TestHelper
  # test "subscribes" do
  #   subscribe
  #   assert subscription.confirmed?
  # end
  setup do 
    @product = products(:Pants)
    @product.update(inventory_count: 0) 
  end 
  test "send notifications when product back in stock" do
    assert_broadcast_on("notifications", type: "restock" , product:{
          id: @product.id,
          name: @product.name,
          price: @product.price}) do
      @product.update(inventory_count: 99)
  end 

  test "do not broadcast when the nventory count equal to 0 and positive"  do
    assertـnoـbroadcast("notifications") do
      @product.update(inventory_count: 0)
    end
  end
  end
end
