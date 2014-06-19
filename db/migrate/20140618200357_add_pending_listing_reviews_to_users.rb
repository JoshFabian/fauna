class AddPendingListingReviewsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pending_listing_reviews, :integer, default: 0
    add_index :users, :pending_listing_reviews
  end
end
