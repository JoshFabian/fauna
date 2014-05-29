class AddUserDataFields < ActiveRecord::Migration
  def change
    add_column :users, :about, :text
    add_column :users, :data, :text
    add_column :users, :phone, :string, limit: 30
    add_column :users, :website, :string, limit: 100
  end
end
