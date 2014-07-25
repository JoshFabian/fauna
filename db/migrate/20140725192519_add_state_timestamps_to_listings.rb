class AddStateTimestampsToListings < ActiveRecord::Migration
  def change
    add_column :listings, :flagged_at, :datetime
    add_column :listings, :removed_at, :datetime

    add_index :listings, :flagged_at
    add_index :listings, :removed_at
  end
end
