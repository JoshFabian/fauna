class DomainRoute
  def matches?(request)
    return true if request.host == "fauna.net"
    false
  rescue Exception => e
    false
  end
end