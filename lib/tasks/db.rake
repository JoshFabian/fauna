namespace :db do

  desc "Re-index search indices"
  task :index_all => :environment do
    puts "#{Time.now}: index_all starting"
    ElasticIndex.delete_all
    ElasticIndex.create_all
    ElasticIndex.index_all
    puts "#{Time.now}: index_all completed"
  end

  desc "Load dataset from db/data.yml, reset search indices"
  task :x => ["db:migrate", "db:data:load", "db:index_all"] do
    puts "#{Time.now}: completed"
  end

  namespace :data do
    desc "Dump contents of database to ENV['DIR']/data.timestamp.yml or db/data.timestamp.yml"
    task :dump_to_file => :environment do
      format_class = ENV['class'] || "YamlDb::Helper"
      helper = format_class.constantize
      data_dir = ENV['DIR'] || "#{Rails.root}/db"
      data_file = "#{data_dir}/data.#{Rails.env}.#{Time.now.to_s(:datetime_compact)}.yml"
      SerializationHelper::Base.new(helper).dump(data_file)
    end

    desc "Load contents of ENV['FILE'] into database"
    task :load_from_file => :environment do
      format_class = ENV['class'] || "YamlDb::Helper"
      helper = format_class.constantize
      data_file = ENV["FILE"]
      raise Exception, "missing file" if data_file.blank?
      # normalize file name
      if data_file.match(/^\//).blank?
        data_file = "#{Rails.root}/#{data_file}"
      end
      raise Exception, "invalid file: #{data_file}" if !File.exists?(data_file)
      puts "#{Time.now}: loading file #{data_file}"
      # SerializationHelper::Base.new(helper).load(data_file)
      # Rake::Task['db:index_all'].invoke
      puts "#{Time.now}: completed"
    end
  end
end