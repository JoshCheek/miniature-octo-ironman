require 'moi/manifest'

RSpec.describe 'Moi::Manifest' do
  def endpoint_for(attributes)
    Moi::Manifest::Endpoint.new attributes
  end

  # raises error if multiple repos have same owner and endpoint

  it 'receives an array of hashes or endpoints that it converts to endpoints' do
    endpoints = [ {repo: 'repo1', ref: 'ref1', file: 'file1', owner: 'owner1', path: 'path1'},
                  Moi::Manifest::Endpoint.new(repo: 'repo2', ref: 'ref2', file: 'file2', owner: 'owner1', path: 'path2')]
    manifest = Moi::Manifest.new endpoints
    expect(manifest.size).to eq 2
    expect(manifest[0].repo).to eq 'repo1'
    expect(manifest[1].repo).to eq 'repo2'
  end

  it 'has all that Enumerable shit' do
    endpoints = [ {repo: 'repo1', ref: 'ref1', file: 'file1', owner: 'owner1', path: 'path1'},
                  Moi::Manifest::Endpoint.new(repo: 'repo2', ref: 'ref2', file: 'file2', owner: 'owner1', path: 'path2')]
    manifest = Moi::Manifest.new endpoints
    expect(manifest.map(&:repo)).to eq %w[repo1 repo2]
  end

  describe 'Moi::Manifest::Endpoint' do
    let(:repo)             { 'somerepo'   }
    let(:ref)              { 'someref'    }
    let(:file)             { 'somefile'   }
    let(:owner)            { 'someowner'  }
    let(:path)             { 'somepath'   }
    let(:valid_attributes) {{repo: repo, ref: ref, file: file, owner: owner, path: path}}

    it 'has an git repo, ref, file, owner, and path' do
      manifest = endpoint_for valid_attributes
      expect(manifest.repo ).to eq repo
      expect(manifest.ref  ).to eq ref
      expect(manifest.file ).to eq file
      expect(manifest.owner).to eq owner
      expect(manifest.path ).to eq path
    end

    it 'optionally takes a localpath' do
      endpoint = endpoint_for(valid_attributes)
      expect(endpoint.localpath).to eq nil

      endpoint = endpoint_for(valid_attributes.merge localpath: 'somepath')
      expect(endpoint.localpath).to eq 'somepath'
    end

    it 'raises an error if any attributes are missing' do
      endpoint_without = lambda do |*keys|
        invalid_attributs = valid_attributes.reject { |k, v| keys.any? { |key| key == k } }
        endpoint_for invalid_attributs
      end
      expect { valid_attributes }.to_not raise_error
      expect { endpoint_without[:repo ]}.to raise_error ArgumentError, /Missing attributes: \[:repo\]/
      expect { endpoint_without[:ref  ]}.to raise_error ArgumentError, /Missing attributes: \[:ref\]/
      expect { endpoint_without[:file ]}.to raise_error ArgumentError, /Missing attributes: \[:file\]/
      expect { endpoint_without[:owner]}.to raise_error ArgumentError, /Missing attributes: \[:owner\]/
      expect { endpoint_without[:path ]}.to raise_error ArgumentError, /Missing attributes: \[:path\]/
    end

    it 'raises an error if extra keys are provided' do
      expect { endpoint_for valid_attributes.merge(extra: 'val') }
        .to raise_error ArgumentError, /Extra attributes: \[:extra\]/
    end
  end
end
