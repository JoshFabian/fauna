class Oauth < ActiveRecord::Base
  belongs_to :user

  validates :user, :presence => true, :uniqueness => {:scope => :provider}

  def facebook?
    self.provider == 'facebook'
  end

  def revoke_facebook_share_permission!
    raise Exception, "not facebook" if self.provider != 'facebook'
    graph = Koala::Facebook::API.new(self.oauth_token)
    # returns true or exception
    result = graph.delete_connections('me', 'permissions/publish_actions')
    # update share flag
    self.update(facebook_share_permission: 0)
    result
  rescue Exception => e
    false
  end

  # create oauth object from omniauth auth hash
  def self.from_omniauth(auth)
    o = where(auth.slice(:provider, :uid)).first_or_initialize.tap do |oauth|
      oauth.user_id = auth.user_id if auth.user_id.present?
      oauth.provider = auth.provider
      oauth.uid = auth.uid
      oauth.oauth_token = auth.credentials.token
      oauth.oauth_expires_at = Time.at(auth.credentials.expires_at) rescue nil
    end
    o.save
    o
  end

end