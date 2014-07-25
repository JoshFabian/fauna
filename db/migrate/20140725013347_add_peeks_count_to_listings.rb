class AddPeeksCountToListings < ActiveRecord::Migration
  def change
    add_column :listings, :peeks_count, :integer, default: 0
    add_index :listings, :peeks_count
  end
end
