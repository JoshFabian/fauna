class AddSoldAtToListings < ActiveRecord::Migration
  def change
    add_column :listings, :sold_at, :datetime
    add_index :listings, :sold_at
  end
end
