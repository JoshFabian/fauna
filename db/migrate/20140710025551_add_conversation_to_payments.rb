class AddConversationToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :conversation_id, :integer
    add_index :payments, :conversation_id
  end
end
