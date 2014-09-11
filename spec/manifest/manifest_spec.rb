require 'moi/manifest'

RSpec.describe 'Moi::Manifest' do
  def endpoint_for(attributes)
    Moi::Manifest::Endpoint.new attributes
  end

  # TODO invalid if multiple repos have same owner and endpoint

  it 'allows access to the endpoint via the owner/webpath pair'

  it 'receives an array of hashes or endpoints that it converts to endpoints' do
    endpoints = [ {repopath: 'repo1', ref: 'ref1', main_filename: 'file1', owner: 'owner1', webpath: 'webpath1'},
                  Moi::Manifest::Endpoint.new(repopath: 'repo2', ref: 'ref2', main_filename: 'file2', owner: 'owner1', webpath: 'webpath2')]
    manifest = Moi::Manifest.new endpoints
    expect(manifest.size).to eq 2
    expect(manifest[0].repopath).to eq 'repo1'
    expect(manifest[1].repopath).to eq 'repo2'
  end

  it 'has all that Enumerable shit' do
    endpoints = [ {repopath: 'repo1', ref: 'ref1', main_filename: 'file1', owner: 'owner1', webpath: 'webpath1'},
                  Moi::Manifest::Endpoint.new(repopath: 'repo2', ref: 'ref2', main_filename: 'file2', owner: 'owner1', webpath: 'webpath2')]
    manifest = Moi::Manifest.new endpoints
    expect(manifest.map(&:repopath)).to eq %w[repo1 repo2]
  end
end
