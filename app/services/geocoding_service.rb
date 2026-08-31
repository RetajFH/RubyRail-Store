class GeocodingService
  Result = Struct.new(:city_name, :success, :error, keyword_init: true)
  BASE_URL = "https://us1.locationiq.com/v1"
  CITY_KEYS = %w[city town village municipality].freeze

  def self.reverse_geocode(lat:, lng:)
    new.reverse_geocode(lat: lat, lng: lng)
  end

  def reverse_geocode(lat:, lng:)
    return Result.new(success: false, error: "Missing coordinates") if lat.blank? || lng.blank?

    uri = URI("#{BASE_URL}/reverse")
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

    extract_city(data)
  rescue StandardError => e
    Rails.logger.error("Geocoding failed: #{e.message}")
    Result.new(success: false, error: "Geocoding service unavailable")
  end

  private

  def extract_city(data)
    address = data["address"] || {}
    name = address.values_at(*CITY_KEYS).find(&:present?)

    return Result.new(success: false, error: "No city found for these coordinates") if name.blank?

    Result.new(success: true, city_name: name)
  end

  def api_key
    ENV.fetch("LOCATIONIQ_API_KEY")
  end
end