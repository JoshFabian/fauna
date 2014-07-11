namespace :rubber do

  namespace :backburner do

    rubber.allow_optional_tasks(self)

    after "deploy:restart", "rubber:backburner:restart"

    desc "Stops the backburner service"
    task :stop, :roles => :app, :on_error => :continue do
      rsudo "kill `cat /mnt/tegu-#{Rubber.env}/shared/pids/backburner.pid`"
      rsudo "rm /mnt/tegu-#{Rubber.env}/shared/pids/backburner.pid"
    end

    desc "Starts the backburner service"
    task :start, :roles => :app do
      rsudo "cd /mnt/tegu-#{Rubber.env}/current && bundle exec backburner -d -P /mnt/tegu-#{Rubber.env}/shared/pids/backburner.pid -l /mnt/tegu-#{Rubber.env}/shared/log/backburner.log"
    end

    desc "Restarts the backburner service"
    task :restart, :roles => :app do
      stop
      start
    end

    desc "Reloads the backburner service"
    task :reload, :roles => :app do
      restart
    end
  end # backburner

end