class AddDataToUserFollow < ActiveRecord::Migration
  def change
    add_column :user_follows, :data, :text
  end
end
