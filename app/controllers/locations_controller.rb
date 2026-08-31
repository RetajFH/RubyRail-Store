class LocationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    result = GeocodingService.reverse_geocode(lat: params[:lat], lng: params[:lng])
    return render json: { error: result.error }, status: :unprocessable_entity unless result.success

    city = City.find_by("LOWER(name) = ?", result.city_name.downcase)
    Current.user.update!(city: city) if city

    render json: city_payload(city, result.city_name), status: :ok
  end

  private

  def city_payload(city, fallback_name)
    return { city: { name: fallback_name }, matched: false } if city.nil?

    { city: { id: city.id, name: city.name }, matched: true }
  end
end