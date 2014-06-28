class AddShippingFieldsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :listing_price, :integer, default: 0
    add_column :payments, :shipping_price, :integer, default: 0
    add_column :payments, :shipping_to, :string, limit: 20

    add_index :payments, :listing_price
    add_index :payments, :shipping_price
    add_index :payments, :shipping_to
  end
end
