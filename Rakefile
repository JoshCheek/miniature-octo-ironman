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

  desc 'Restart the server'
  task(:restart) { ssh 'cd ~/miniature-octo-ironman; chruby-exec 2.1.2 -- bundle exec pumactl --config-file puma_config.rb restart' }
end
