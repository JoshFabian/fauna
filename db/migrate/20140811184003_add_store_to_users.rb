class AddStoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :store, :boolean, defalt: false
    add_index :users, :store
  end
end
