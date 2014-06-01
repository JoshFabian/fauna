class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :listing
      t.integer :buyer_id
      t.string :state, limit: 20
      t.string :key, limit: 100
      t.string :payment_url
      t.string :error_message
      t.datetime :canceled_at
      t.datetime :completed_at
      t.timestamps
    end

    add_index :payments, :listing_id
    add_index :payments, :buyer_id
    add_index :payments, :state
    add_index :payments, :key
    add_index :payments, :canceled_at
    add_index :payments, :completed_at
    add_index :payments, :created_at
  end
end
