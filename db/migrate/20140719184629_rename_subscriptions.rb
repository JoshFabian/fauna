class RenameSubscriptions < ActiveRecord::Migration
  def change
    rename_table :subscriptions, :plan_subscriptions
  end
end
