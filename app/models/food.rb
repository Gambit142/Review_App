class Food < ApplicationRecord
  belongs_to :restaurant
  serialize :steps, Array
  serialize :ingredients, Array
  has_many :reviews, as: :reviewable
end
