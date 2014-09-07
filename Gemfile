source 'https://rubygems.org'

require 'rubygems'
req    = Gem::Requirement.new('~> 2.1.0')
dflt   = Gem::Version.new '2.1.2'
crnt   = Gem::Version.new(RUBY_VERSION)
chosen = req.satisfied_by?(crnt) ? crnt : dflt
ruby(chosen.version)


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
