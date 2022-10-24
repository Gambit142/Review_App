class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :comment, :likes
  has_one :reviewable
  has_one :user
end
