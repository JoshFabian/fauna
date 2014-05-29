class CreateUserImages < ActiveRecord::Migration
  def change
    create_table :user_avatar_images do |t|
      t.references :user
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

    add_index :user_avatar_images, :user_id
    add_index :user_avatar_images, :position

    create_table :user_cover_images do |t|
      t.references :user
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

    add_index :user_cover_images, :user_id
    add_index :user_cover_images, :position
  end
end
