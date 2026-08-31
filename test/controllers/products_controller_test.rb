require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = create(:product)
  end

  context "when user are authenticated" do
    setup do
      @user = users(:one)
      sign_in_as @user
    end

    should "user can create a new product" do
      product_attrs = attributes_for(:product)

      assert_difference("Product.count", 1) do
        post products_path, params: { product: product_attrs }
      end
      assert_redirected_to product_path(Product.last)
    end

    should "user can update a existing product" do
      patch product_path(@product), params: {
        product: { name: "Updated Name", price: 40 }
      }

      assert_redirected_to product_path(@product)
      @product.reload
      assert_equal "Updated Name", @product.name
    end
  end

  context "when user are unauthenticated" do
    should "user can't create a new product" do
      product_attrs = attributes_for(:product)

      assert_no_difference("Product.count") do
        post products_path, params: { product: product_attrs }
      end
    end

    should "not allow updating a product" do
      original_name = @product.name

      patch product_path(@product), params: {
        product: { name: "Hacked Name" }
      }
      assert_equal original_name, @product.reload.name
    end
  end
end
