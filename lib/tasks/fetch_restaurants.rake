task :restaurants => :environment do
  require 'json'
  require 'digest'

  # Fetch restaurants from hotelbeds API
  date = Time.now.to_i
  api_key = ENV['HOTELBEDS_API_KEY']
  secret = ENV['HOTELBEDS_SECRET']

  combined_key = "#{api_key}#{secret}#{date}"
  encrypted_key = Digest::SHA256.hexdigest(combined_key).chomp()

  headers = {
    'X-Signature' => encrypted_key,
    'Api-key' => api_key,
    'Accept' => 'application/json'
  }

  # Fetch Restaurants from HotelBeds API and retain relevant data

  def fetch_restaurants(headers, continentCodes)
    continentCodes.map do |code|
      url = "https://api.test.hotelbeds.com/hotel-content-api/1.0/hotels?countryCode=#{code}&from=1&to=5"
      response = HTTParty.get(url, headers: headers)
      data = JSON.parse response.body
      next if response.code != 200 || response.body.nil? || response.body.empty?

      data = JSON.parse(response.body)
      data['hotels'].map do |hotel|
        image = hotel['images']&.find { |image| image['imageTypeCode'] == 'RES' } || hotel['images']&.first
        c = Country[code]
        country = c.iso_short_name
        continent = c.region == 'Americas' ? c.subregion : c.region 
        {
          name: hotel['name']['content'],
          description: hotel['description']['content'],
          countryCode: code,
          country: country,
          continent: continent,
          address: "#{hotel['address']['number']} #{hotel['address']['street']}, #{hotel['city']['content'].capitalize}",
          email: hotel['email'],
          website: hotel['web'],
          image: image ? "http://photos.hotelbeds.com/giata/#{image['path']}" : nil
        }
      end
    end.flatten
  end

  # Create JSON file with restaurants data

  def create_json_file(file_name, data)
    Dir.mkdir('json') unless File.exists?('json')
    return if File.exists?("json/#{file_name}.json")
    File.open("json/#{file_name}.json","w") do |f|
      f.write(JSON.pretty_generate(data))
    end
  end

  def save_data_to_json(headers, continentCodes, file_name)
    data = fetch_restaurants(headers, continentCodes)
    create_json_file(file_name, data)
  end
  
  # Save data to Various JSON files
  save_data_to_json(headers, ['JP', 'SG', 'CN', 'KR', 'IN', 'TH'], 'asian_restaurants')
  save_data_to_json(headers, ['EG', 'NG', 'ZA', 'AO', 'GH', 'TZ'], 'african_restaurants')
  save_data_to_json(headers, ['US', 'CA', 'MX', 'PR', 'CU', 'DO'], 'north_american_restaurants')
  save_data_to_json(headers, ['BR', 'AR', 'CO', 'PE', 'CL', 'VE'], 'south_american_restaurants')
  save_data_to_json(headers, ['AU', 'NZ', 'PG', 'FJ', 'NC', 'SB'], 'australian_restaurants')
  save_data_to_json(headers, ['GB', 'DE', 'FR', 'IT', 'ES', 'RU'], 'european_restaurants')

end
