require 'moi/manifest'

RSpec.describe 'Moi::Manifest' do
  def endpoint_for(attributes)
    Moi::Manifest::Endpoint.new attributes
  end

  # TODO invalid if multiple repos have same owner and endpoint

  it 'allows access to the endpoint via the owner/webpath pair'

  it 'receives an array of hashes or endpoints that it converts to endpoints' do
    endpoints = [ {repo: 'repo1', ref: 'ref1', file: 'file1', owner: 'owner1', webpath: 'webpath1'},
                  Moi::Manifest::Endpoint.new(repo: 'repo2', ref: 'ref2', file: 'file2', owner: 'owner1', webpath: 'webpath2')]
    manifest = Moi::Manifest.new endpoints
    expect(manifest.size).to eq 2
    expect(manifest[0].repo).to eq 'repo1'
    expect(manifest[1].repo).to eq 'repo2'
  end

  it 'has all that Enumerable shit' do
    endpoints = [ {repo: 'repo1', ref: 'ref1', file: 'file1', owner: 'owner1', webpath: 'webpath1'},
                  Moi::Manifest::Endpoint.new(repo: 'repo2', ref: 'ref2', file: 'file2', owner: 'owner1', webpath: 'webpath2')]
    manifest = Moi::Manifest.new endpoints
    expect(manifest.map(&:repo)).to eq %w[repo1 repo2]
  end
end
