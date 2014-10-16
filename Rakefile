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
  desc 'Open the prod website'
  task :open do
    sh 'open http://104.131.24.233'
  end

  def self.ssh(command=nil)
    script = "ssh miniature-octo-ironman@104.131.24.233"
    require 'shellwords'
    script << " " << command.shellescape if command.kind_of?(String)
    sh script
  end

  desc 'Ssh into prod box'
  task(:ssh) { ssh }

  desc 'Install the prod binary'
  # task(:install_bin) { ssh '
end
