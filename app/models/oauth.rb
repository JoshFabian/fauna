class Oauth < ActiveRecord::Base
  belongs_to :user

  validates :user, :presence => true, :uniqueness => {:scope => :provider}

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

  def facebook_publish_permission?
    raise Exception, "not facebook" if self.provider != 'facebook'
    graph = Koala::Facebook::API.new(self.oauth_token)
    objects = graph.get_connections('me', 'permissions').select do |hash|
      hash['permission'] == 'publish_actions' and hash['status'] == 'granted'
    end
    objects.any?
  rescue Exception => e
    false
  end

  def revoke_facebook_publish_permission!
    raise Exception, "not facebook" if self.provider != 'facebook'
    graph = Koala::Facebook::API.new(self.oauth_token)
    # returns true or exception
    graph.delete_connections('me', 'permissions/publish_actions')
  rescue Exception => e
    false
  end

end