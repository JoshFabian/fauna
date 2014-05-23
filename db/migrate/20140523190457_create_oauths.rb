class CreateOauths < ActiveRecord::Migration
  def change
    create_table :oauths do |t|
      t.references :user
      t.string :provider, :limit => 20
      t.string :uid, :limit => 50
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.text :data
    end

    add_index :oauths, :user_id
    add_index :oauths, :provider
    add_index :oauths, :uid
  end
end
