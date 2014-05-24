class CreateListingImages < ActiveRecord::Migration
  def change
    create_table :listing_images do |t|
      t.references :listing
      t.integer :position
      t.string :etag, limit: 100
      t.string :public_id, limit: 100
      t.string :version, limit: 100
      t.integer :bytes
      t.integer :height
      t.integer :width
      t.string :format, limit: 100
      t.string :resource_type, limit: 100
      t.timestamps
    end

    add_index :listing_images, :listing_id
    add_index :listing_images, :position

    add_column :listings, :images_count, :integer, default: 0
    add_index :listings, :images_count
  end
end
