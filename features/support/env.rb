# load our helpers
$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'support/shitty_stub' # TODO: These get required here, but then loaded by Cucumber afterwards. Idk how everyone else deals with this, might become a problem
require 'support/our_helpers'

# Turn off the spammy html error page, it's good in dev, not in test
MiniatureOctoIronman.set :show_exceptions, false

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

Before do
  # stupid hack that won't work for long
  # need to inject the data dir, set it to a tmpfile or something
  # this is going to wipe out any real data we happen to have
  # There is now a middleware to inject eval_in, go there and inject the data dir
  file_helper.reset_datadir

  # Stupid hack because the manifest is a singleton.
  # which causes it to blow up on our tests because we wipe out the data dir
  # so that the tests don't interfere with each other, but this object still has
  # an internal reference to the previous endpoints.
  #
  # We need to load it anew each time a request comes in.
  OurHelpers.manifest.endpoints.clear
end

# Remove stubs
After do
  CukeStubs.unstub
end
