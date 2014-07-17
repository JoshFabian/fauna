class CreateUserFollows < ActiveRecord::Migration
  def change
    create_table :user_follows do |t|
      t.integer :user_id
      t.integer :following_id
      t.datetime :following_at
      t.timestamps
    end

    add_index :user_follows, :user_id
    add_index :user_follows, :following_id
    add_index :user_follows, :following_at
    add_index :user_follows, :created_at

    add_column :users, :followers_count, :integer, default: 0
    add_index  :users, :followers_count
  end
end
