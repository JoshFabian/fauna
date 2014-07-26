class Comment < ActiveRecord::Base
  include Loggy

  validates :body, presence: true
  validates :commentable_id, presence: true
  validates :commentable_type, presence: true
  validates :user, presence: true

  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count
  belongs_to :user

  store :data, accessors: [:email_sent]

  # return true if an email notification has been sent
  def email_sent?
    self.email_sent.to_i == 1
  end

  # returns true if someone should be notified when this object is created
  def notify?
    true
  end
end