source 'https://rubygems.org'

require File.expand_path('../lib/moi/ruby_dependency', __FILE__)
ruby Moi::RubyDependency.call requirement: '~> 2.1.0',
                              default:     '2.1.2',
                              current:     RUBY_VERSION

gem 'haml',        '~> 4.0'
gem 'eval_in',     '~> 0.1.6'
gem 'redcarpet',   '~> 3.1'
gem 'rdiscount',   '~> 2.1.7'
gem 'sinatra',     '~> 1.4'

group :test do
  gem 'webmock',     '~> 1.18'
  gem 'launchy',     '~> 2.4'
  gem 'rspec',       '~> 3.0'
  gem 'cucumber',    '~> 1.3'
  gem 'capybara',    '~> 2.4'
  gem 'poltergeist', '~> 1.5'
  gem 'pry',         '~> 0.10'
end
