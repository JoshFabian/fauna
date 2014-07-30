class OauthObserver < ActiveRecord::Observer
  include Loggy

  def after_save(oauth)
    if oauth.oauth_token_changed? and oauth.facebook?
      facebook_cache_permissions!(oauth)
    end
  rescue Exception => e
  end

  protected

  def facebook_cache_permissions!(oauth)
    raise Exception, "test env" if Rails.env.test?
    graph = Koala::Facebook::API.new(oauth.oauth_token)
    objects = graph.get_connections('me', 'permissions').select do |hash|
      hash['permission'] == 'publish_actions' and hash['status'] == 'granted'
    end
    if objects.any?
      oauth.update_column(:facebook_share_permission, true)
    else
      oauth.update_column(:facebook_share_permission, false)
    end
    objects.any?
  rescue Exception => e
    false
  end

end