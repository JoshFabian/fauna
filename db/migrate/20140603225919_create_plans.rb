class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, limit: 50
      t.string :state, limit: 20
      t.integer :amount
      t.boolean :subscription
      t.string :interval, limit: 20
      t.integer :interval_count
      t.integer :trial_period_days
      t.integer :subscriptions_count, default: 0
      t.text :data
      t.timestamps
    end

    add_index :plans, :name
    add_index :plans, :state
    add_index :plans, :amount
    add_index :plans, :subscription
    add_index :plans, :interval
    add_index :plans, :interval_count
    add_index :plans, :trial_period_days

    create_table :subscriptions do |t|
      t.references :user
      t.references :plan
      t.text :data
      t.timestamps
    end

    add_index :subscriptions, :user_id
    add_index :subscriptions, :plan_id

    # users table
    add_column :users, :customer_id, :string, limit: 100
    add_column :users, :subscriptions_count, :integer, default: 0

    add_index :users, :customer_id
    add_index :users, :subscriptions_count
  end
end
