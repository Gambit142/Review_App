task :foods => :environment do
  require 'json'

  # Fetch foods from spoonacular API

  def fetch_food_function(parameters)
    spoonacular_api_key = ENV['SPOONACULAR_API_KEY']
    base_url = 'https://api.spoonacular.com/recipes/complexSearch?'
    base_url += "apiKey=#{spoonacular_api_key}"
    parameters.each do |key, value|
      base_url += "&#{key}=#{value}"
    end
    response = HTTParty.get(base_url)
    data = JSON.parse response.body
  end

  first_parameters = {
    addRecipeInformation: true,
    type: 'breakfast'
  }

  second_parameters = {
    addRecipeInformation: true,
    type: 'main course'
  }

  third_parameters = {
    addRecipeInformation: true,
    type: 'dessert',
  }

  food_data1 = fetch_food_function(first_parameters)['results']
  food_data2 = fetch_food_function(second_parameters)['results']
  food_data3 = fetch_food_function(third_parameters)['results']

  def food_json_file(json_file, food_data)
    File.open("json/#{json_file}.json","w") do |f|
      f.write(JSON.pretty_generate(food_data))
    end
  end

  food_json_file('food_breakfast', food_data1)
  food_json_file('food_main_course', food_data2)
  food_json_file('food_dessert', food_data3)
end