class AddUserLocationFields < ActiveRecord::Migration
  def change
    add_column :users, :street, :string, limit: 60
    add_column :users, :city, :string, limit: 60
    add_column :users, :state_code, :string, limit: 2
    add_column :users, :postal_code, :string, limit: 16
    add_column :users, :lat, :decimal, precision: 15, scale: 10
    add_column :users, :lng, :decimal, precision: 15, scale: 10
    
    add_index :users, :state_code
    add_index :users, :postal_code
  end
end
