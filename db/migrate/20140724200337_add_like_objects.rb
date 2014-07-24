class AddLikeObjects < ActiveRecord::Migration
  def change
    create_table :listing_likes do |t|
      t.references :listing
      t.references :user
      t.timestamps
    end

    add_index :listing_likes, :listing_id
    add_index :listing_likes, :user_id
    add_index :listing_likes, :created_at

    add_column :listings, :likes_count, :integer, default: 0
    add_index :listings, :likes_count

    create_table :post_likes do |t|
      t.references :post
      t.references :user
      t.timestamps
    end

    add_index :post_likes, :post_id
    add_index :post_likes, :user_id
    add_index :post_likes, :created_at

    add_column :posts, :likes_count, :integer, default: 0
    add_index :posts, :likes_count
  end
end
