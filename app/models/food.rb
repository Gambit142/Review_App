class Food < ApplicationRecord
  belongs_to :restaurant
  serialize :steps, Array
  serialize :ingredients, Array
end
