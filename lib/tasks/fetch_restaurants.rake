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

  def fetch_restaurants(headers, continentCodes)
    continentCodes.map do |code|
      url = "https://api.test.hotelbeds.com/hotel-content-api/1.0/hotels?countryCode=#{code}&from=1&to=5"
      response = HTTParty.get(url, headers: headers)
      data = JSON.parse(response.body)
      data['hotels'].map do |hotel|
        image = hotel['images'].find { |image| image['imageTypeCode'] == 'RES' }
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
          image: "http://photos.hotelbeds.com/giata/#{image['path']}"
        }
      end
    end.flatten
  end

  asia_restaurants = fetch_restaurants(headers, ['JP', 'SG', 'CN', 'KR', 'IN', 'TH'])

  # response = HTTParty.get('https://api.test.hotelbeds.com/hotel-content-api/1.0/hotels?countryCode=TH&to=100', headers: headers)
  # data = JSON.parse response.body

  Dir.mkdir('json') unless File.exists?('json')
  File.open("json/restaurants.json","w") do |f|
    f.write(JSON.pretty_generate(data))
  end

  # puts "👋👋 #{fetch_restaurants(headers, ['JP', 'SG', 'CN', 'KR', 'IN', 'TH'])}"

end