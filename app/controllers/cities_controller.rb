class CitiesController < ApplicationController
  before_action :require_admin
  before_action :set_city, only: %i[edit update destroy]

  def index
    @cities = City.order(:name)
  end

  def new
    @city = City.new
  end

  def create
    @city = City.new(city_params)

    if @city.save
      redirect_to cities_path, notice: "City created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @city.update(city_params)
      redirect_to cities_path, notice: "City updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @city.destroy
    redirect_to cities_path, notice: "City deleted successfully."
  end

  private

  def set_city
    @city = City.find(params[:id])
  end

  def city_params
    params.require(:city).permit(:name)
  end
end