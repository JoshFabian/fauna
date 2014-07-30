namespace :db do

  namespace :search do
    desc "Re-import search indices"
    task :import_all => :environment do
      puts "#{Time.now}: import_all starting"
      # delete indices, create, and import
      ElasticIndex.import_all(force: true)
      puts "#{Time.now}: import_all completed"
    end
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

    desc "Load most recent database backup, reset search indices"
    task :load_recent => ["db:migrate"] do
      format_class = ENV['class'] || "YamlDb::Helper"
      helper = format_class.constantize
      data_file = Dir["#{Rails.root}/db/data*"].sort.last
      puts "#{Time.now}: loading file: #{data_file}"
      SerializationHelper::Base.new(helper).load(data_file)
      Rake::Task['db:search:import_all'].invoke
      puts "#{Time.now}: completed"
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
      SerializationHelper::Base.new(helper).load(data_file)
      Rake::Task['db:index_all'].invoke
      puts "#{Time.now}: completed"
    end
  end
end