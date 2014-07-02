class HandleRoute
  # def initialize
  #     @passthru = ["/auth/facebook", "/auth/twitter"]
  # end

  def matches?(request)
    return false if request.path.match(/^\/(about|auth|invites|landing|listings|listing_reports|login|logout|messages|payments|paypal|plans|reviews|signup|sms|tags|users|waitlists)/)
    true
  end
end