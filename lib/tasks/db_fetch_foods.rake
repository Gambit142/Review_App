task :foods => :environment do
  require 'json'

  # Fetch foods from spoonacular API

  spoonacular_api_key = ENV['SPOONACULAR_API_KEY']
  base_url = 'https://api.spoonacular.com/recipes/complexSearch?'
  parameters = {
    apiKey: spoonacular_api_key,
    addRecipeInformation: true,
    type: 'breakfast'
  }
  parameters.each do |key, value|
    base_url += "&#{key}=#{value}"
  end

  response = HTTParty.get(base_url)
  data = JSON.parse response.body

end