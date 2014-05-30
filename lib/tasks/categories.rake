namespace :categories do
  
  desc "Import categories"
  task :import => :environment do
    puts "#{Time.now}: importing categories"
    objects = YAML::load(File.open("#{Rails.root}/data/categories.yml"))
    objects.each do |s|
      root, *children = s
      root = Category.find_or_create_by(name: root)
      puts "#{Time.now}: root:#{root.name}"
      children.flatten.each do |s|
        root.children.find_or_create_by(name: s)
        puts "#{Time.now}: root:#{root.name}:child:#{s}"
      end
    end
    puts "#{Time.now}: completed"
  end

  desc "Import category images"
  task :import_images => :environment do
    puts "#{Time.now}: importing category images"
    Category.roots.each do |category|
      next if category.cover_image.present?
      name = category.name.downcase.split(' ').first
      path = "#{Rails.root}/data/images/#{name}.jpg"
      category.cover_image = File.open(path, 'r')
      category.save
    end
    puts "#{Time.now}: completed"
  end
end