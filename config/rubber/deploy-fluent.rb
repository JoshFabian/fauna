namespace :rubber do
  namespace :fluent do

    desc "Install fluentd"
    task :install, :roles => :app do
      run "gem install fluentd"
      run "gem install fluent-plugin-file-alternative"
      # run "sudo yum install -y td-agent"
      # run "curl -L http://toolbelt.treasuredata.com/sh/install-redhat.sh | sh"
    end

    desc "Configure fluentd"
    task :configure, :roles => :app do
      # file copy not required when common/fluent.conf present
      # run "mkdir -p /etc/fluent"
      # run "cp #{deploy_to}/current/config/rubber/common/fluent.#{rails_env}.conf /etc/fluent/fluent.conf"
      # run "sudo cp #{deploy_to}/current/config/fluentd/init.d/init /etc/init.d/td-agent"
      # run "sudo cp #{deploy_to}/current/config/fluentd/plugins/out_file_alternative.rb /etc/td-agent/plugin/"
    end

    desc "Start fluentd"
    task :start, :roles => :app do
      run "sudo /etc/init.d/td-agent start"
    end

    desc "Stop fluentd"
    task :stop, :roles => :app do
      run "sudo /etc/init.d/td-agent stop"
    end

    desc "Restart fluentd"
    task :restart, :roles => :app do
      run "sudo /etc/init.d/td-agent restart"
    end

    desc "Get status of fluentd"
    task :status, :roles => :app do
      run "sudo /etc/init.d/td-agent status"
    end
  end
end