require 'moi/manifest/persist_to_json'

RSpec.describe 'Moi::Manifest::PersistToJSON' do
  def endpoint_for(attributes)
    Moi::Manifest::Endpoint.new attributes
  end

  let(:json_path) { File.expand_path("../../json_save_test.json", __FILE__) }
  let(:persist_to_json) { Moi::Manifest::PersistToJSON.new json_path }

  it 'saves a manifest to a JSON file' do
    endpoints = [ {repopath: 'json-repo-test1', ref: 'ref1', main_filename: 'file1', owner: 'owner1', webpath: 'webpath1', datadir: 'datadir1', localpath: 'localpath1'},
                  endpoint_for(repopath: 'json-repo-test2', ref: 'ref2', main_filename: 'file2', owner: 'owner2', webpath: 'webpath2', datadir: 'datadir2', localpath: 'localpath2')]
    manifest = Moi::Manifest.new endpoints
    persist_to_json.save(manifest)
    expect(File.read(json_path)).to match /repopath.*:.*json-repo-test/
  end

  it 'loads a manifest from a JSON file' do
    manifest = persist_to_json.load
    expect(manifest.map(&:repopath)).to eq %w[json-repo-test1 json-repo-test2]
  end
end
