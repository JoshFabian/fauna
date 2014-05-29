class UserAvatarImage < ActiveRecord::Base
  include Loggy

  belongs_to :user, touch: true

  validates :public_id, presence: true
  validates :user, presence: true
  validates :version, presence: true

  acts_as_list scope: :user

  def full_public_id
    "v#{self.version}/#{self.public_id}.#{self.format}"
  end
end