class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :description
      t.string :country_code
      t.string :country
      t.string :continent
      t.string :address
      t.string :email
      t.string :website
      t.string :image

      t.timestamps
    end
  end
end
