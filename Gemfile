source 'https://rubygems.org'

# Interact with git (pull down repos to render for the manifest)
gem 'rugged',        '~> 0.21.0'

# serving the site
gem 'puma',          '~> 2.9'   # web server
gem 'sinatra',       '~> 1.4'   # web framework

# handling requests
gem 'eval_in',       '~> 0.1.6' # evaluate ruby code safely

# rendering
gem 'haml',          '~> 4.0'   # Alternative syntax for HTML, our layout is the only thing that uses it currently
gem 'redcarpet',     '~> 3.1'   # markdown parser

# support
gem 'rake',          '~> 10.3'   # easily run tasks from the command-line

# these will not be installed in production (Heroku)
group :test do
  gem 'pry',         '~> 0.10'  # because who would ever want to develop in an env without this?
  gem 'webmock',     '~> 1.18'  # to lock down the web, making sure we don't hit services while running tests
  gem 'rspec',       '~> 3.0'   # unit test suite
  gem 'cucumber',    '~> 1.3'   # integration test suite
  gem 'capybara',    '~> 2.4'   # navigate our site through the internet
  gem 'poltergeist', '~> 1.5'   # let capybara navigate in phantom.js web browser, so our js executes
  gem 'launchy',     '~> 2.4'   # enables the "open" part of save_and_open_page/screenshot in capybara
end
