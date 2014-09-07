# load our helpers
$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'support/shitty_stub' # TODO: These get required here, but then loaded by Cucumber afterwards. Idk how everyone else deals with this, might become a problem
require 'support/our_helpers'

# Start our server
OurHelpers.start_server
at_exit { OurHelpers.stop_server }

# Don't accidentally go hitting services during tests
require 'webmock'
WebMock.disable_net_connect!

# Custom stub lib since RSpec mocks apparently doesn't work
CukeStubs = ShittyStub.new

# Things to add to the Cucumber world
require 'rspec'
World OurHelpers,
      RSpec::Expectations,
      RSpec::Matchers,
      RSpec::Mocks::ExampleMethods

# Hijack the server to look at our custom views
Before do
  copy_views
  server.set :views, views_dir
end

# Remove stubs
After do
  CukeStubs.unstub
end
