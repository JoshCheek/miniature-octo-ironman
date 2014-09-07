$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'support/stupid_stub_lib'
require 'support/our_helpers'


# Start our server
OurHelpers.start_server
at_exit { OurHelpers.stop_server }

# Don't accidentally go hitting services during tests
require 'webmock'
WebMock.disable_net_connect!

# We'll stick our stubs here
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

Given 'eval.in will serve "$url" as:' do |url, json|
  parsed_json = JSON.parse(json).merge('url' => url)
  result      = EvalIn.build_result(parsed_json)
  CukeStubs.stub self, EvalIn, :call, result
end

Given 'I have a document "$name":' do |name, body|
  File.write path_to_view(name), body
end

When 'I visit "$path"' do |path|
  require 'redcarpet'
  internet.visit "http://localhost:1235#{path}"
end

Then 'my page has "$content" on it' do |content|
  expect(internet.body).to include content
end

Then 'my page has an editor with "$content"' do |content|
  internet.within editor_class do
    expect(internet).to have_content(content)
  end
end

When 'I submit the code in the editor' do
  internet.click_on 'Run'
end

Then 'I see an output box with "$content" in it' do |content|
  expect(internet).to have_css displayed_result_class, text: content
end
