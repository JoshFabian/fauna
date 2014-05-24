class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.references :user
      t.string :state, limit: 20
      t.string :title, limit: 100
      t.text :description
      t.integer :price
      t.timestamps
    end

    add_index :listings, :user_id
    add_index :listings, :state
    add_index :listings, :title
    add_index :listings, :price
    add_index :listings, :created_at
  end
end
