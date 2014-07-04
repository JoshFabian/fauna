class AddListingsCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :listings_count, :integer, default: 0
    add_index :categories, :listings_count
  end
end
