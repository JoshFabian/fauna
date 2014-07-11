namespace :rubber do

  namespace :beanstalkd do

    rubber.allow_optional_tasks(self)

    after "rubber:install_packages", "rubber:beanstalkd:install"

    task :install, :roles => :app do
      rsudo "apt-get install beanstalkd"
    end
  end # beanstalkd

end