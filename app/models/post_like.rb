class PostLike < ActiveRecord::Base
  include Loggy

  validates :post, presence: true
  validates :user, presence: true, uniqueness: {scope: :post}

  belongs_to :post, counter_cache: :likes_count
  belongs_to :user

  def self.like?(post, user)
    post.likes.where(user_id: user.respond_to?(:id) ? user.id : user).exists?
  rescue Exception => e
    false
  end

  def self.like!(post, user)
    post.likes.create!(user: user)
    true
  rescue Exception => e
    false
  end

  def self.unlike!(post, user)
    post.likes.find_by_user_id(user.respond_to?(:id) ? user.id : user).destroy
    true
  rescue Exception => e
    false
  end

  def self.toggle_like!(post, user)
    if like?(post, user)
      unlike!(post, user)
    else
      like!(post, user)
    end
    true
  rescue Exception => e
    false
  end

  def self.likes(post)
    self.where(post_id: post.respond_to?(:id) ? post.id : post)
  end
end