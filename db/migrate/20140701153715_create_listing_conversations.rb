class CreateListingConversations < ActiveRecord::Migration
  def change
    create_table :listing_conversations do |t|
      t.references :conversation
      t.references :listing
      t.timestamps
    end

    add_index :listing_conversations, :conversation_id
    add_index :listing_conversations, :listing_id
    add_index :listing_conversations, :created_at
  end
end
