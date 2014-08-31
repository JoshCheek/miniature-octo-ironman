require 'fileutils'
require 'rspec'
require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  options = {
    js_errors: false
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

$LOAD_PATH.unshift '../../../lib', __FILE__
require 'app'

module OurHelpers
  class << self
    attr_accessor :server_thread
  end

  extend self

  def views_dir
    @views_dir ||= begin
      dir = File.expand_path '../../../tmp', __FILE__
      FileUtils.mkdir_p dir
      dir
    end
  end

  def path_to_view(name)
    File.join views_dir, name
  end

  def server
    MiniatureOctoIronman
  end

  def internet
    @internet ||= Capybara.current_session
  end

  def start_server
    OurHelpers.server_thread = Thread.new { OurHelpers.server.run! }
  end

  def stop_server
    OurHelpers.server_thread && OurHelpers.server_thread.kill("INT")
  end
end

OurHelpers.start_server
at_exit { OurHelpers.stop_server }

World OurHelpers,
      RSpec::Expectations,
      RSpec::Matchers


Before do
  server.set :views, views_dir
end

Given 'I have a document "$name":' do |name, body|
  # internet.visit "http://localhost:4567/a"
  # internet.save_and_open_page
  File.write path_to_view(name), body
end

When 'I visit "$path"' do |path|
  internet.visit "http://localhost:4567#{path}"
end

Then 'my page has "$content" on it' do |content|
  expect(internet.body).to include content
end

Then 'my page has an editor with "$content"' do |content|
  pending
end

When 'I submit the code in editor $index' do |index|
  pending
end

Then 'I see an output box with "$content" in it' do |arg1|
  pending
end
