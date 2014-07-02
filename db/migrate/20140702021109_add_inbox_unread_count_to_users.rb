class AddInboxUnreadCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :inbox_unread_count, :integer, default: 0
    add_index :users, :inbox_unread_count
  end
end
