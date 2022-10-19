class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :country_code, :country, :continent, :address, :email, :website, :image
end
