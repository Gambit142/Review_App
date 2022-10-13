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
  response = HTTParty.get('https://api.test.hotelbeds.com/hotel-content-api/1.0/hotels', headers: headers)
  data = JSON.parse response.body

  Dir.mkdir('json') unless File.exists?('json')
  File.open("json/restaurant.json","w") do |f|
    f.write(JSON.pretty_generate(data))
  end

end