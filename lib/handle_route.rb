class HandleRoute
  # def initialize
  #     @passthru = ["/auth/facebook", "/auth/twitter"]
  # end

  def matches?(request)
    s = "(about|auth|categories|invites|landing|listings|listing_reports|login|logout|messages|payments|paypal|plans|reviews|signup|sms|stories|tags|users|waitlists)"
    return false if request.path.match(/^\/#{s}/)
    true
  end
end