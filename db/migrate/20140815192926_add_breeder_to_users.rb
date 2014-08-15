class AddBreederToUsers < ActiveRecord::Migration
  def change
    add_column :users, :breeder, :boolean, default: false
    add_index :users, :breeder
  end
end
