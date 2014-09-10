Given 'eval.in will serve "$url" as:' do |url, json|
  parsed_json = JSON.parse(json).merge('url' => url)
  result      = EvalIn.build_result(parsed_json)
  CukeStubs.stub EvalIn, :call, result
end

Given 'I have a document "$name":' do |name, body|
  File.write path_to_view(name), body
end

require 'moi/manifest/endpoint'
def endpoint
  config = {
    repo:    'https://github.com/JoshCheek/miniature-octo-ironman.git',
    ref:     'someref',
    file:    'somefile',
    owner:   'someowner',
    webpath: 'somewebpath',
    datadir: '/somedatadir'
  }
  Moi::Manifest::Endpoint.new(config)
end

require_relative '../../spec/spec_helper'
Given /^the git repo exists$/ do
  file_helper = FsHelpers.new File.expand_path '../../tmp', __FILE__
  file_helper.reset_datadir
  file_helper.make_upstream_repo
end

Given /^I have a configuration$/  do
  MiniatureOctoIronman::ENDPOINT_CONFIGURATION = [endpoint]
end

When 'I visit "$path"' do |path|
  require 'redcarpet' # TODO: Wat is this?
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
