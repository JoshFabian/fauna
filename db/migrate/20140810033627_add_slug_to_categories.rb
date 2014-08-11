class AddSlugToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :slug, :string, limit: 50
    add_index :categories, :slug
  end
end
