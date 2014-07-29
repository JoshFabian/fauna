class Post < ActiveRecord::Base
  include Loggy
  include Elasticsearch::Model

  validates :body, presence: true
  validates :user, presence: true
  validates :wall_id, presence: true

  belongs_to :user, counter_cache: :posts_count

  has_many :comments, as: :commentable
  has_many :likes, class_name: "PostLike", dependent: :destroy

  store :data, accessors: [:facebook_share_id]

  # set search index name
  index_name "posts.#{Rails.env}"

  before_validation(on: :create) do
    self.wall_id ||= self.user_id
  end

  def as_indexed_json(options={})
    as_json(methods: [:state], except: [:data])
  end

  def facebook_shared?
    self.facebook_share_id.present?
  end

  def should_update_index!
    self.__elasticsearch__.index_document rescue nil
  end

  def state
    'active'
  end
end
