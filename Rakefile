desc 'Set up the dev environment'
task :bootstrap do
  # phantom          | for testing the js/server interaction
  # cmake/pkg-config | dependencies for installing rugged, which gives us bindings into git
  sh "gem install bundler"
  sh "brew install phantomjs cmake pkg-config"
  sh "bundle install"
end

desc 'Run cucumber tests'
task :cuke do
  sh 'bundle exec cucumber'
end

desc 'Start the server'
task :server do
  sh 'bundle exec rackup'
end

task default: :cuke
