require_relative 'geocoding'


class Address
  attr_accessor :lat, :lng, :full_address, :last_distance

  def initialize(args = {})
    @lat = args[:lat] if args[:lat]
    @lng = args[:lng] if args[:lng]
    @full_address = args[:full_address] if args[:full_address]
  end

  def miles_to(destination)
    Geocoder::Calculations.distance_between(self.coordinates, destination.coordinates)
  end

  def find_address
    @result = AccessGeocoder.reverse_geocode(self.lat, self.lng).first.data["usa"]
    self.full_address = "#{@result['usstnumber']} #{@result['usstaddress']}, #{@result['uscity']} #{@result['state']} #{@result['zip']}"
  end

  def find_lat_lng
    @result = AccessGeocoder.geocode(self.full_address).first.data
    self.lng = @result['longt']
    self.lat = @result['latt']
  end

  def geocoded?
    defined?(lat) && defined?(lng)
  end

  def reverse_geocoded?
    defined?(full_address)
  end

  def coordinates
    [self.lat, self.lng]
  end

end
