require 'fileutils'
require 'rspec'
require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist

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
   require 'webrick'
   OurHelpers.server_thread = Thread.new {
     Rack::Server.start app: OurHelpers.server.new, Port: 1235, server: 'webrick', AccessLog: [] , Logger: WEBrick::Log.new(StringIO.new)
   }
  end

  def stop_server
      OurHelpers.server_thread && OurHelpers.server_thread.kill
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
  require 'redcarpet'
  internet.visit "http://localhost:1235#{path}"
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
