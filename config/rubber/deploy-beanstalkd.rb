namespace :rubber do

  namespace :beanstalkd do

    rubber.allow_optional_tasks(self)

    after "rubber:install_packages", "rubber:beanstalkd:install"

    task :install, :roles => :app do
      rsudo "apt-get install beanstalkd"
    end

    desc "Stops the beanstalkd server"
    task :stop, :roles => :app do
      rsudo "service beanstalkd stop; exit 0"
    end

    desc "Starts the beanstalkd server"
    task :start, :roles => :app do
      rsudo "service beanstalkd status || service beanstalkd start"
    end
  end # beanstalkd

end