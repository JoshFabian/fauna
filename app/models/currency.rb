module Currency

  def to_cents(s)
    if s.is_a?(String)
      if s.match(/^\$\d+\.\d+/)
        # dollars and cents
        s = s.gsub(/[.$]/, '').to_i
      elsif s.match(/^\$\d+/)
        # dollars
        s = s.gsub(/[.$]/, '').to_i * 100
      else
        # convert string to integer
        s = s.to_i
      end
    end # string
    s
  end

end