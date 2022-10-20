task :foods => :environment do
  require 'json'

  # Fetch foods from spoonacular API

  def fetch_food_function(cuisine)
    spoonacular_api_key = ENV['SPOONACULAR_API_KEY']
    base_url = 'https://api.spoonacular.com/recipes/complexSearch?'
    base_url += "apiKey=#{spoonacular_api_key}"
    parameters = {
      addRecipeInformation: true,
      cuisine: cuisine,
    }
    parameters.each do |key, value|
      base_url += "&#{key}=#{value}"
    end
    response = HTTParty.get(base_url)
    data = JSON.parse response.body
    data = data['results']
  end

  # Save food data to JSON file

  def create_food_attributes(cuisine)
    data = fetch_food_function(cuisine)
    data.map do |food|
      {
        name: food['title'],
        
      }

    end
  end

  food_data1 = fetch_food_function('African')
  food_data2 = fetch_food_function('American')
  food_data3 = fetch_food_function('Caribbean')

  def food_json_file(json_file, food_data)
    File.open("json/#{json_file}.json","w") do |f|
      f.write(JSON.pretty_generate(food_data))
    end
  end

  food_json_file('African_dishes', food_data1)
  food_json_file('American_dishes', food_data2)
  food_json_file('Caribbean_dishes', food_data3)
end