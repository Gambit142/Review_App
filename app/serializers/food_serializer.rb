class FoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :food_details, :image, :steps, :ingredients
  has_one :restaurant
end
