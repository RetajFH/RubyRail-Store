# app/services/geocoding_service.rb
require "net/http"
require "json"
require "uri"

class GeocodingService
  Result = Struct.new(:city_name, :success, :error, keyword_init: true)

  def self.reverse_geocode(lat:, lng:)
    new.reverse_geocode(lat: lat, lng: lng)
  end

  def reverse_geocode(lat:, lng:)
    return Result.new(success: false, error: "Missing coordinates") if lat.blank? || lng.blank?

    uri = URI("https://us1.locationiq.com/v1/reverse")
   uri.query = URI.encode_www_form(
  key: api_key,
  lat: lat,
  lon: lng,
  format: "json"
)

    response = Net::HTTP.get_response(uri)
    data = JSON.parse(response.body)

    if data["error"]
      return Result.new(success: false, error: data["error"])
    end

    address = data["address"] || {}
    city_name = address["city"] || address["town"] || address["village"] || address["municipality"]

    if city_name
      Result.new(success: true, city_name: city_name)
    else
      Result.new(success: false, error: "No city found for these coordinates")
    end
  rescue StandardError => e
    Rails.logger.error("Geocoding failed: #{e.message}")
    Result.new(success: false, error: "Geocoding service unavailable")
  end

  private

  def api_key
    ENV.fetch("LOCATIONIQ_API_KEY")
  end
end