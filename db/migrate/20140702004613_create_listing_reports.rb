class CreateListingReports < ActiveRecord::Migration
  def change
    create_table :listing_reports do |t|
      t.references :listing
      t.references :user
      t.text :data
      t.timestamps
    end

    add_index :listing_reports, :listing_id
    add_index :listing_reports, :user_id
    add_index :listing_reports, :created_at
  end
end
