class HandleRoute
  # def initialize
  #     @passthru = ["/auth/facebook", "/auth/twitter"]
  # end

  def matches?(request)
    return false if request.path.match(/^\/(auth|invites|landing|listings|login|logout|payments|signup|sms|tags|users|waitlists)/)
    true
  end
end