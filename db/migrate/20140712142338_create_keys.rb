class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :env, limit: 20
      t.string :name, limit: 20
      t.string :value, limit: 100
    end

    add_index :keys, :env
    add_index :keys, :name
  end
end
