namespace :categories do
  
  desc "Import categories"
  task :import => :environment do
    puts "#{Time.now}: importing categories"
    objects = YAML::load(File.open("#{Rails.root}/data/categories.yml"))
    objects.each do |s|
      Category.create(name: s)
    end
    puts "#{Time.now}: completed"
  end
end