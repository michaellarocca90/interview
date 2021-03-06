RSpec.describe Address do
  let(:full_address) { '1600 Pennsylvania Avenue NW Washington, D.C. 20500 U.S.' }
  let(:lat) { 40.181306 }
  let(:lng) { -80.265949 }

  subject(:address) { described_class.new }

  describe 'geocoding' do
    let(:payload) {{  'longt' => lng, 'latt' => lat }}
    let(:result) { [ double(data: payload) ] }

    it 'geocodes with Geocoder API' do
      address.full_address = full_address
      expect(Geocoder).to receive(:search).with(full_address).and_return result
      address.find_lat_lng()
    end

    it 'is geocoded' do
      expect(address).to be_geocoded
    end
  end

  describe 'reverse geocoding' do
    let :payload do
      {
        'usa'=> {
          'uscity' => 'WASHINGTON',
          'usstnumber' => '1',
          'state' => 'PA',
          'zip' => '20500',
          'usstaddress' => 'Pennsylvania AVE'
        }
      }
    end

    let(:result) { [ double(data: payload) ] }

    it 'reverse geocodes with Geocoder API' do
      address.lat = lat
      address.lng = lng
      expect(Geocoder).to receive(:search).with("#{lat}, #{lng}").and_return result
      address.find_address
    end

    it 'is reverse geocoded' do
      expect(address).to be_reverse_geocoded
    end
  end

  describe 'distance finding' do
    let(:detroit) { FactoryGirl.build :address, :as_detroit }
    let(:kansas_city) { FactoryGirl.build :address, :as_kansas_city }

    it 'calculates distance with the Geocoder API' do
      expect(Geocoder::Calculations).to receive(:distance_between).with detroit.coordinates, kansas_city.coordinates
      detroit.miles_to(kansas_city)
    end

    it 'returns the distance between two addresses' do
      expect(detroit.miles_to(kansas_city)).to be > 0
    end
  end
end
