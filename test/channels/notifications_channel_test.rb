require "test_helper"

class NotificationsChannelTest < ActionCable::Channel::TestCase
  include ActionCable::TestHelper
  include ActiveJob::TestHelper

  setup do
    @product = products(:Pants)
    @product.update!(inventory_count: 0)
  end

  test "send notifications when product back in stock" do
    assert_broadcast_on("notifications", type: "restock", product: {
      id: @product.id,
      name: @product.name,
      price: @product.price
    }) do
      perform_enqueued_jobs do
        @product.update!(inventory_count: 99)
      end
    end
  end

  test "do not broadcast when inventory count stays at zero" do
    assert_no_broadcasts("notifications") do
      perform_enqueued_jobs do
        @product.update!(inventory_count: 0)
      end
    end
  end
end