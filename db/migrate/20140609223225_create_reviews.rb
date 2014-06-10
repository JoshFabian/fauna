class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :listing
      t.float :avg_rating, default: 0.0
      t.text :body
      t.text :data
      t.timestamps
    end

    add_index :reviews, :user_id
    add_index :reviews, :listing_id
    add_index :reviews, :avg_rating
    add_index :reviews, :created_at

    create_table :review_ratings do |t|
      t.references :review
      t.string :name, limit: 20
      t.float :rating, default: 0.0
    end

    add_index :review_ratings, :review_id
    add_index :review_ratings, :name
    add_index :review_ratings, :rating
  end
end
