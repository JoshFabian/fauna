class AddPaypalEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paypal_email, :string, limit: 100
    add_index :users, :paypal_email
  end
end
