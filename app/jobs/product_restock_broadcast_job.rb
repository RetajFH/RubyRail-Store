class ProductRestockBroadcastJob < ApplicationJob
  queue_as :default

  def perform(product)
    ActionCable.server.broadcast(
      "notifications",
      {
        type: "restock",
        product: {
          id: product.id,
          name: product.name,
          price: product.price
        }
      }
    )
  end
end
