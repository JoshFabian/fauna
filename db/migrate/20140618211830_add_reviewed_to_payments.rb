class AddReviewedToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :reviewed, :boolean, default: false
    add_index :payments, :reviewed
  end
end
