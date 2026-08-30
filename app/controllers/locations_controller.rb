# app/controllers/locations_controller.rb
class LocationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    result = GeocodingService.reverse_geocode(lat: params[:lat], lng: params[:lng])

    unless result.success
      return render json: { error: result.error }, status: :unprocessable_entity
    end

    city = City.find_by("LOWER(name) = ?", result.city_name.downcase)

    if city
      Current.user.update!(city: city)
      render json: { city: { id: city.id, name: city.name }, matched: true }, status: :ok
    else
      render json: { city: { name: result.city_name }, matched: false }, status: :ok
    end
  end
end