require 'moi/manifest'

RSpec.describe 'Moi::Manifest' do
  def endpoint_for(attributes)
    Moi::Manifest::Endpoint.new attributes
  end

  # TODO invalid if multiple repos have same owner and endpoint

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

  describe 'Moi::Manifest::Endpoint' do
    let(:repo)             { 'somerepo'    }
    let(:ref)              { 'someref'     }
    let(:file)             { 'somefile'    }
    let(:owner)            { 'someowner'   }
    let(:webpath)          { 'somewebpath' }
    let(:valid_attributes) {{repo: repo, ref: ref, file: file, owner: owner, webpath: webpath}}

    it 'has an git repo, ref, file, owner, and webpath' do
      manifest = endpoint_for valid_attributes
      expect(manifest.repo   ).to eq repo
      expect(manifest.ref    ).to eq ref
      expect(manifest.file   ).to eq file
      expect(manifest.owner  ).to eq owner
      expect(manifest.webpath).to eq webpath
    end

    it 'optionally takes a localpath' do
      endpoint = endpoint_for(valid_attributes)
      expect(endpoint.localpath).to eq nil

      endpoint = endpoint_for(valid_attributes.merge localpath: 'somepath')
      expect(endpoint.localpath).to eq 'somepath'
    end

    context 'validation/errors' do
      def each_invalid
        [:repo, :ref, :file, :owner, :webpath].each do |attribute|
          invalid_attributs = valid_attributes.reject { |k, v| k == attribute }
          yield attribute, endpoint_for(invalid_attributs)
        end
      end

      it 'is invalid if any mandatory attributes are missing' do
        expect(endpoint_for valid_attributes).to be_valid
        expect(endpoint_for valid_attributes.merge(localpath: 'somepath')).to be_valid
        each_invalid { |attribute, endpoint| expect(endpoint).to_not be_valid }
      end

      it 'is invalid if any extra keys are provided' do
        expect(endpoint_for valid_attributes.merge(extra: 'val')).to_not be_valid
      end

      it 'has a nil error string when all attributes are available' do
        expect(endpoint_for(valid_attributes).error).to be_nil
        expect(endpoint_for(valid_attributes.merge(localpath: 'somepath')).error).to be_nil
      end

      it 'has an error string that explains what keys are missing' do
        each_invalid do |attribute, endpoint|
          expect(endpoint.error).to eq "Missing attributes: [#{attribute.inspect}]"
        end
      end

      it 'has an error string that explains what keys are extra' do
        expect(endpoint_for(valid_attributes.merge extra: 'val').error).to eq "Extra attributes: [:extra]"
      end
    end
  end
end
