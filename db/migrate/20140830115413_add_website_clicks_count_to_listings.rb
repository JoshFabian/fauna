class AddWebsiteClicksCountToListings < ActiveRecord::Migration
  def change
    add_column :listings, :website_clicks_count, :integer, default: 0
    add_index :listings, :website_clicks_count
  end
end
