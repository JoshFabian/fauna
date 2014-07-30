class AddFacebookSharePermissionToOauth < ActiveRecord::Migration
  def change
    add_column :oauths, :facebook_share_permission, :boolean, default: false
    add_index :oauths, :facebook_share_permission
  end
end
