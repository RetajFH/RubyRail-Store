class ProductsController < ApplicationController
  before_action :require_admin, only: %i[new create edit update destroy]
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @min_price = params[:min_price]
    @max_price = params[:max_price]
    @search_by_name = params[:search_name]
    @user_city = Current.user&.city

    if invalid_price_range?
      flash.now[:alert] = "Minimum price cannot be greater than maximum price"
      @products = Product.none
      return
    end

    @products = filtered_products
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.expect(
      product: [
        :name,
        :description,
        :featured_image,
        :inventory_count,
        :price,
        :sizes,
        city_ids: []
      ]
    )
  end

  def invalid_price_range?
    @min_price.present? && @max_price.present? && @min_price.to_f > @max_price.to_f
  end

  def filtered_products_by_city
    if !admin? && @user_city
      Product.available_in(@user_city)
    else
      Product.all
    end
  end

  def filtered_products
    products = filtered_products_by_city
    products = products.price_gteq(@min_price) if @min_price.present?
    products = products.price_lteq(@max_price) if @max_price.present?
    products = products.search_by_name(@search_by_name) if @search_by_name.present?
    products
  end
end