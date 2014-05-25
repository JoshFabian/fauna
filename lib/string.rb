class String
  def detokenize
    self.downcase.gsub(/[\s-]/,'')
  end

  def wildcard
    self + "*"
  end
end