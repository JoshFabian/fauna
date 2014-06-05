class AddUserStripeFields < ActiveRecord::Migration
  def change
    add_column :users, :listing_credits, :integer, default: 0
    add_index :users, :listing_credits
  end
end
