desc 'Set up the dev environment'
task :bootstrap do
  sh "brew install phantomjs"
  sh "bundle install"
end

desc 'Run cucumber tests'
task :cuke do
  sh 'bundle exec cucumber'
end
