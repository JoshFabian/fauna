class AddWallCountersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wall_comments_count, :integer, default: 0
    add_column :users, :wall_likes_count, :integer, default: 0

    add_index :users, :wall_comments_count
    add_index :users, :wall_likes_count
  end
end
