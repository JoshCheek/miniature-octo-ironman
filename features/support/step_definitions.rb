Given 'eval.in will serve "$url" as:' do |url, json|
  parsed_json = JSON.parse(json).merge('url' => url)
  result      = EvalIn.build_result(parsed_json)
  CukeStubs.stub EvalIn, :call, result
end

Given /^the git repo exists$/ do # TODO: Move this into a before filter?
  file_helper.reset_datadir
  file_helper.make_upstream_repo
end

Given /^I have a configuration$/  do
  MiniatureOctoIronman::ENDPOINT_CONFIGURATION.endpoints << endpoint
end

Given 'the git repo has the file "$filename"' do |filename, body|
  file_helper.cd file_helper.upstream_repo_path do
    file_helper.write filename, body
    file_helper.sh "git add ."
    file_helper.sh "git commit -m 'some commit'"
    e = MiniatureOctoIronman::ENDPOINT_CONFIGURATION.endpoints.last
    e.main_filename = filename
    e.ref = file_helper.current_sha('.')
  end
end

When 'I visit "$path"' do |path|
  internet.visit "http://localhost:1235#{path}"
end

Then 'my page has "$content" on it' do |content|
  expect(internet.body).to include content
end

Then 'my page has the SHA from the repo' do
  expect(internet.response_headers.values).to include MiniatureOctoIronman::ENDPOINT_CONFIGURATION.endpoints.last.ref
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

Given 'I have a git repo' do
  file_helper.cd file_helper.upstream_repo_path do
    file_helper.write "the_filename.txt", "this is the file I'm testing"
    file_helper.sh "git add ."
    file_helper.sh "git commit -m 'some commit'"
  end
end

When 'I submit in the endpoint form with this repo\'s data' do
  internet.fill_in "endpoint[repopath]", with: file_helper.upstream_repo_path
  internet.fill_in "endpoint[ref]", with: "master"
  internet.fill_in "endpoint[main_filename]", with: "the_filename.txt"
  internet.fill_in "endpoint[owner]", with: "other"
  internet.fill_in "endpoint[webpath]", with: "test_example"
  internet.all("input").last.click
end

Then "my endpoint has been persisted to the server's json file" do
  manifest = Moi::Manifest::PersistToJSON.new(MiniatureOctoIronman::JSON_FILE).load
  refs = manifest.map(&:ref)
  expect(refs).to include MiniatureOctoIronman::ENDPOINT_CONFIGURATION.endpoints[-2].ref
  # hey, we need to fix the dependencies for these tests. The endpoint object in
  # the Given /^I have a configuration$/ test is then being changed in the very
  # next test, so we have no local object that holds it's current ref, so we
  # are checking that the 2nd to last endpoint created in the manifest was written
  # but this dependency could use a lot of change
end

When 'I visit the page holding this repo\'s main file' do
  internet.visit "http://localhost:1235/other/test_example"
end

Then 'I see the file from the repo' do
  expect(internet.body).to include "this is the file I'm testing"
end

Then 'I can see a link to the repo I created' do
  expect(internet.body).to include "other/test_example"
end
