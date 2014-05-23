class Oauth < ActiveRecord::Base
  belongs_to :user

  validates :user, :presence => true, :uniqueness => {:scope => :provider}

  # create oauth object from omniauth auth hash
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |oauth|
      oauth.user_id = auth.user_id if auth.user_id.present?
      oauth.provider = auth.provider
      oauth.uid = auth.uid
      oauth.oauth_token = auth.credentials.token
      oauth.oauth_expires_at = Time.at(auth.credentials.expires_at)
    end
  end

end