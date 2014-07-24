class ListingFilter

  def self.category(id)
    {term: {category_ids: id}}
  end

  def self.state(s)
    {term: {state: s}}
  end

  def self.user(id)
    {term: {user_id: id}}
  end

end