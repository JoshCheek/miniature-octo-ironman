desc 'Set up the dev environment'
task :bootstrap do
  sh "gem install bundler"
  sh "brew install phantomjs"
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



# Faking out https://github.com/vizify/heroku-buildpack-multi/blob/04c4a692e464e5e52bd193c8e6a3d68a004d3aa1/bin/compile#L86
#
# Necessary to compile on Heroku using the vizify/multi buildpack
# Have to use this one, b/c ddollar/multi (the one on Heroku, not the one on Github) doesn't pass the env dir,
# which the Ruby buildpack expects: https://github.com/heroku/heroku-buildpack-ruby/blob/bf71b01eab57390808226898cf091f08a4c93e3e/bin/compile#L12
#
# For a rant about this, read https://github.com/JoshCheek/heroku-buildpack-for-cmake-and-pkg-config/blob/master/bin/release
namespace :vizify do
  task :node_compile do
  end
end
