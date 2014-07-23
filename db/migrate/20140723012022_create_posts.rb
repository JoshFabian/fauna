class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.integer :wall_id
      t.integer :comments_count, default: 0
      t.text :body
      t.text :data
      t.timestamps
    end

    add_index :posts, :user_id
    add_index :posts, :wall_id
    add_index :posts, :comments_count
    add_index :posts, :created_at

    add_column :listings, :comments_count, :integer, default: 0
    add_index :listings, :comments_count

    add_column :users, :posts_count, :integer, default: 0
    add_index :users, :posts_count

    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.references :user
      t.string :body
      t.text :data
      t.timestamps
    end

    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :user_id
  end
end
