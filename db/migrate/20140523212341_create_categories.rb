class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, limit: 100
      t.integer :parent_id
      t.integer :level
      t.integer :children_count, default: 0
      t.timestamps
    end

    add_index :categories, :name
    add_index :categories, :parent_id
    add_index :categories, :level
    add_index :categories, :children_count

    create_table :listing_categories do |t|
      t.references :category
      t.references :listing
      t.timestamps
    end

    add_index :listing_categories, :category_id
    add_index :listing_categories, :listing_id
  end
end
