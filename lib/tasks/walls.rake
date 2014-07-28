namespace :walls do

  desc "Count wall comments and likes"
  task :recount => :environment do
    puts "#{Time.now}: counting wall comments and likes ..."
    User.find_each do |user|
      Wall.total_comments(user)
      Wall.total_likes(user)
    end
    puts "#{Time.now}: counting completed"
  end

end