class Search

  def self.wildcard_query(q)
    q.split.map{ |s| s.match(/^[a-zA-Z0-9]*$/) ? "#{s}*" : s}.join(' ')
  rescue Exception => e
    s
  end

end