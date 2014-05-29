class Category < ActiveRecord::Base
  include Loggy
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, presence: true, uniqueness: true

  has_many :listing_categories
  has_many :listings, through: :listing_categories

  acts_as_tree order: :name, counter_cache: :children_count
  acts_as_list scope: [:level]

  # set search index name
  index_name "categories.#{Rails.env}"

  before_validation(on: :create) do
    self.level = get_parent_level + 1
  end

  def self.roots
    Category.where(level: 1)
  end

  protected

  def get_parent_level
    parent.blank? ? 0 : parent.try(:level).to_i
  end
end