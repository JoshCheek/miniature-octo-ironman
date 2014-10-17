task default: [:spec, :cuke]

# SETUP
desc 'Set up the dev environment'
task :bootstrap do
  # phantom          | for testing the js/server interaction
  # cmake/pkg-config | dependencies for installing rugged, which gives us bindings into git
  sh "gem install bundler"
  sh "brew install phantomjs cmake pkg-config"
  sh "bundle install"
end

# TESTS
desc 'Run Cucumber tests'
task :cuke do
  sh 'bundle exec cucumber'
end

desc 'Start the server'
task :server do
  sh 'bundle exec rackup'
end

desc 'Run RSpec tests'
task :spec do
  sh 'bundle exec rspec'
end

# MANAGING PROD
namespace :prod do
  ip = '104.131.24.233'

  desc 'Open the prod website'
  task :open do
    sh "open http://#{ip}"
  end

  define_singleton_method :ssh do |command=nil|
    script = "ssh miniature-octo-ironman@#{ip}"
    require 'shellwords'
    script << " " << command.shellescape if command.kind_of?(String)
    sh script
  end

  desc 'Ssh into prod box'
  task(:ssh) { ssh }

  desc 'Restart the server (from local machine)'
  task(:restart)           { ssh 'cd ~/miniature-octo-ironman && rake prod:restart_from_prod' }
  task(:restart_from_prod) { sh  'cd ~/miniature-octo-ironman && chruby-exec 2.1.2 -- bundle exec pumactl --config-file puma_config.rb restart' }

  namespace :git do
    desc 'Pull the master branch from GH so that the server has the latest changes'
    task :pull do
      task(:restart) { ssh 'cd ~/miniature-octo-ironman && '\
                           'git diff --quiet            && '\
                           'git diff --cached --quiet   && '\
                           'git pull origin master:master'  }
    end

    desc 'Ensure prod is on master branch'
    task(:master) { ssh 'cd ~/miniature-octo-ironman && git checkout master' }
  end

  desc 'Deploy the code to the server (from Github\'s master branch)'
  task deploy: ['prod:git:pull', 'prod:git:master', 'prod:restart']
end
