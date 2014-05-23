gemfile = File.expand_path(File.join(__FILE__, '..', 'Gemfile'))
if ENV['RUBBER_ENV'].nil?
  # check environment
  if ['staging', 'production'].include?(ARGV[0])
    env = ENV['RUBBER_ENV'] = ENV['RAILS_ENV'] = ARGV[0]
    ARGV.shift
  else
    puts "Please specify an environment, e.g. staging, production"
    exit
  end
  puts "Respawning with 'bundle exec'"
  exec("bundle", "exec", "cap", *ARGV)
end

load 'deploy' if respond_to?(:namespace) # cap2 differentiator

env = ENV['RUBBER_ENV'] ||= (ENV['RAILS_ENV'] || 'production')
root = File.dirname(__FILE__)

# this tries first as a rails plugin then as a gem
$:.unshift "#{root}/vendor/plugins/rubber/lib/"
require 'rubber'

Rubber::initialize(root, env)
require 'rubber/capistrano'

Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'
