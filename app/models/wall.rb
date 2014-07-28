class Wall

  def self.total_comments(user, options={})
    count = user.listings.map{ |o| o.comments.where.not(user_id: user.id).count }.sum +
      user.posts.map{ |o| o.comments.where.not(user_id: user.id).count }.sum
    user.update(wall_comments_count: count)
    count
  rescue Exception => e
    0
  end

  def self.total_likes(user, options={})
    count = user.listings.sum(:likes_count) + user.posts.sum(:likes_count)
    user.update(wall_likes_count: count)
    count
  rescue Exception => e
    0
  end

end