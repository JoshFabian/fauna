class AddImageCropFields < ActiveRecord::Migration
  def change
    # listing images
    add_column :listing_images, :crop_x, :integer, default: 0
    add_column :listing_images, :crop_y, :integer, default: 0
    add_column :listing_images, :crop_h, :integer, default: 0
    add_column :listing_images, :crop_w, :integer, default: 0

    add_index :listing_images, :crop_x
    add_index :listing_images, :crop_y
    add_index :listing_images, :crop_h
    add_index :listing_images, :crop_w

    # user avatar images
    add_column :user_avatar_images, :crop_x, :integer, default: 0
    add_column :user_avatar_images, :crop_y, :integer, default: 0
    add_column :user_avatar_images, :crop_h, :integer, default: 0
    add_column :user_avatar_images, :crop_w, :integer, default: 0

    add_index :user_avatar_images, :crop_x
    add_index :user_avatar_images, :crop_y
    add_index :user_avatar_images, :crop_h
    add_index :user_avatar_images, :crop_w

    # user avatar images
    add_column :user_cover_images, :crop_x, :integer, default: 0
    add_column :user_cover_images, :crop_y, :integer, default: 0
    add_column :user_cover_images, :crop_h, :integer, default: 0
    add_column :user_cover_images, :crop_w, :integer, default: 0

    add_index :user_cover_images, :crop_x
    add_index :user_cover_images, :crop_y
    add_index :user_cover_images, :crop_h
    add_index :user_cover_images, :crop_w
  end
end
