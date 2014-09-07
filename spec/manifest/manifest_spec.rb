require 'moi/manifest'

RSpec.describe 'Moi::Manifest' do
  def endpoint_for(attributes)
    Moi::Manifest::Endpoint.new attributes
  end

  it 'receives an array of hashes or endpoints that it converts to endpoints' do
    endpoints = [ {repo: 'repo1', ref: 'ref1', file: 'file1'},
                  Moi::Manifest::Endpoint.new(repo: 'repo2', ref: 'ref2', file: 'file2')]
    manifest = Moi::Manifest.new endpoints
    expect(manifest.size).to eq 2
    expect(manifest[0].repo).to eq 'repo1'
    expect(manifest[1].repo).to eq 'repo2'
  end

  it 'has all that Enumerable shit' do
    endpoints = [ {repo: 'repo1', ref: 'ref1', file: 'file1'},
                  Moi::Manifest::Endpoint.new(repo: 'repo2', ref: 'ref2', file: 'file2')]
    manifest = Moi::Manifest.new endpoints
    expect(manifest.map(&:repo)).to eq %w[repo1 repo2]
  end

  describe 'Moi::Manifest::Endpoint' do
    let(:repo)             { 'somerepo' }
    let(:ref)              { 'someref'  }
    let(:file)             { 'somefile' }
    let(:valid_attributes) {{repo: repo, ref: ref, file: file}}

    it 'has an endpoint, git repo, ref, and file' do
      manifest = endpoint_for valid_attributes
      expect(manifest.repo).to eq repo
      expect(manifest.ref).to  eq ref
      expect(manifest.file).to eq file
    end

    it 'optionally takes a localpath' do
      endpoint = endpoint_for(valid_attributes)
      expect(endpoint.localpath).to eq nil

      endpoint = endpoint_for(valid_attributes.merge localpath: 'somepath')
      expect(endpoint.localpath).to eq 'somepath'
    end

    it 'raises an error if any attributes are missing' do
      expect { endpoint_for repo: repo, ref: ref, file: file}.to_not raise_error
      expect { endpoint_for             ref: ref, file: file}.to raise_error ArgumentError, /Missing attributes: \[:repo\]/
      expect { endpoint_for repo: repo,           file: file}.to raise_error ArgumentError, /Missing attributes: \[:ref\]/
      expect { endpoint_for repo: repo, ref: ref            }.to raise_error ArgumentError, /Missing attributes: \[:file\]/
      expect { endpoint_for Hash.new                        }.to raise_error ArgumentError, /Missing attributes: \[:repo, :ref, :file\]/
    end

    it 'raises an error if extra keys are provided' do
      expect { endpoint_for valid_attributes.merge(extra: 'val') }
        .to raise_error ArgumentError, /Extra attributes: \[:extra\]/
    end
  end
end
