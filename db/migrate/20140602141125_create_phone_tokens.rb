class CreatePhoneTokens < ActiveRecord::Migration
  def change
    create_table :phone_tokens do |t|
      t.references :user
      t.string :to, limit: 20
      t.string :state, limit: 20
      t.string :code, limit: 10
      t.datetime :sent_at
      t.datetime :verified_at
      t.timestamps
    end

    add_index :phone_tokens, :user_id
    add_index :phone_tokens, :state
    add_index :phone_tokens, :code
    add_index :phone_tokens, :sent_at
    add_index :phone_tokens, :verified_at
  end
end
