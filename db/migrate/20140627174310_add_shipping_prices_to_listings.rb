class AddShippingPricesToListings < ActiveRecord::Migration
  def change
    add_column :listings, :shipping_prices, :text
    add_column :listings, :data, :text
  end
end
