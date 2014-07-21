class AddViewCounts < ActiveRecord::Migration
  def change
    add_column :listings, :views_count, :integer, default: 0
    add_column :users, :views_count, :integer, default: 0

    add_index :listings, :views_count
    add_index :users, :views_count
  end
end
