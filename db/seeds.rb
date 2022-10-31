# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create Restaurants and Foods

def create_restaurants_and_foods(category_name)
  restaurants = Oj.load_file("json/restaurants/#{category_name}_restaurants.json")
  cuisine = Oj.load_file("json/cuisines/#{category_name}_dishes.json")
  restaurants.each do |restaurant|
    res = Restaurant.create(**restaurant)
    res.foods.create_with(created_at: Time.now, updated_at: Time.now).insert_all(cuisine)
  end
end

create_restaurants_and_foods("african")
