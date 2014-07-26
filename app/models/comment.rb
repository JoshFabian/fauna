class Comment < ActiveRecord::Base
  include Loggy

  validates :body, presence: true
  validates :commentable_id, presence: true
  validates :commentable_type, presence: true
  validates :user, presence: true

  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count
  belongs_to :user

  store :data

  def email_sent?
    false
  end
end