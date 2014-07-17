class UserFollow < ActiveRecord::Base
  belongs_to :user, touch: true # user is the follower
  belongs_to :following, touch: true, class_name: "User", counter_cache: :followers_count

  validates :user_id, presence: true
  validates :following_id, presence: true, uniqueness: {scope: :user_id}

  scope :following, -> { where("following_at IS NOT ?", nil) }

  def self.follow!(user, follow)
    o = user.user_follows.find_or_create_by(following_id: follow.respond_to?(:id) ? follow.id : follow)
    o.following_at = Time.zone.now
    o.save
    true
  rescue Exception => e
    false
  end

  def self.unfollow!(user, follow)
    user.user_follows.find_by_following_id(follow.respond_to?(:id) ? follow.id : follow).destroy
    true
  rescue Exception => e
    false
  end

  def self.following?(user, follow)
    UserFollow.where(user_id: user.respond_to?(:id) ? user.id : user,
                     following_id: follow.respond_to?(:id) ? follow.id : follow).following.exists?
  end

  def self.toggle_follow!(user, follow)
    mash = Hashie::Mash.new
    if self.following?(user, follow)
      self.unfollow!(user, follow)
      mash.event = 'unfollow'
    else
      self.follow!(user, follow)
      mash.event = 'follow'
    end
    mash.count = UserFollow.where(following_id: follow.respond_to?(:id) ? follow.id : follow).count
    mash
  end
end
