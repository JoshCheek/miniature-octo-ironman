# load our helpers
$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'support/stupid_stub_lib'
require 'support/our_helpers'

# Start our server
OurHelpers.start_server
at_exit { OurHelpers.stop_server }

# Don't accidentally go hitting services during tests
require 'webmock'
WebMock.disable_net_connect!

# Custom stub lib since RSpec mocks apparently doesn't work
CukeStubs = StupidStubLib.new

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
  CukeStubs.unstub self
end
