class CreateWaitlists < ActiveRecord::Migration
  def change
    create_table :waitlists do |t|
      t.string :email, limit: 50
      t.string :code, limit: 20
      t.string :role, limit: 20
      t.string :referer, limit: 50
      t.integer :signup_count, default: 0
      t.timestamps
    end

    add_index :waitlists, :email
    add_index :waitlists, :code
    add_index :waitlists, :role
    add_index :waitlists, :referer
    add_index :waitlists, :signup_count
  end
end
