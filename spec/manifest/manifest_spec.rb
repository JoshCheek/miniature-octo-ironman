require 'moi/manifest'

RSpec.describe 'Moi::Manifest' do
  describe 'Moi::Manifest::Endpoint' do
    let(:repo)             { 'somerepo' }
    let(:ref)              { 'someref'  }
    let(:file)             { 'somefile' }
    let(:valid_attributes) {{repo: repo, ref: ref, file: file}}

    def endpoint_for(attributes)
      Moi::Manifest::Endpoint.new attributes
    end

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
