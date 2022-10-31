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
      steps = []
      if food['analyzedInstructions'].length > 0
        steps = food['analyzedInstructions'][0]['steps'].map do |step|
          step['step']
        end
      end
      ingredients = []
      if food['analyzedInstructions'].length > 0
        ingredients = food['analyzedInstructions'][0]['steps'].map do |step|
          step['ingredients'].map do |ingredient|
            {
              name: ingredient['name'].capitalize,
              image: "https://spoonacular.com/cdn/ingredients_100x100/#{ingredient['image']}"
            }
          end.compact
        end.flatten if food['analyzedInstructions']
      end
      {
        name: food['title'],
        food_details: food['summary'],
        image_url: food['image'],
        steps: steps,
        ingredients: ingredients
      }
    end
  end

  def save_continental_food_data(*cuisines)
    data = []
    if cuisines.length > 1
      cuisines.each do |cuisine|
        data.concat(create_food_attributes(cuisine))
      end
    else
      data.concat(create_food_attributes(cuisines[0]))
    end
    data
  end

  def save_food_to_json(cuisines, file_name)
    data = save_continental_food_data(*cuisines)
    Dir.mkdir('json/cuisines') unless File.exists?('json/cuisines')
    return if File.exists?("json/cuisines/#{file_name}.json")
    File.open("json/cuisines/#{file_name}.json","w") do |f|
      f.write(JSON.pretty_generate(data))
    end
  end

  # Create JSON file with food data
  eurpoean_cuisines = ['British', 'Eastern European', 'European', 'French', 
                      'German', 'Greek', 'Italian', 'Spanish', 'Irish', 'Nordic']
  north_american_cuisines = ['American', 'Cajun', 'Carribean', 'Mexican', 'Jewish']
  south_american_cuisines = ['Argentinian', 'Brazilian', 'Peruvian']
  australia_cuisines = ['Mediterranean', 'Southern']
  asian_cuisines = ['Chinese', 'Japanese', 'Korean', 'Thai', 'Vietnamese', 'Indian', 'Middle Eastern']

  save_food_to_json('African', 'african_dishes')
  save_food_to_json('Latin American', 'south_american_dishes')
  save_food_to_json(north_american_cuisines, 'north_american_dishes')
  save_food_to_json(eurpoean_cuisines, 'european_dishes')
  save_food_to_json(asian_cuisines, 'asian_dishes')
  save_food_to_json(australia_cuisines, 'australian_dishes')

  # Merge dishes belonging to same continent into one JSON file

end