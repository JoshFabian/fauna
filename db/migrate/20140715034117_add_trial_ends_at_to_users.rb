class AddTrialEndsAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trial_ends_at, :datetime
    add_index :users, :trial_ends_at
  end
end
