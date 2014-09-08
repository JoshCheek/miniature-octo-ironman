require 'moi/manifest'
require 'spec_helper'

describe 'managing Moi::Manifest::Endpoint' do
  Endpoint = Moi::Manifest::Endpoint

  let(:datadir) { File.expand_path '../../../tmp', __FILE__ }
  let(:fs)      { FsHelpers.new datadir }

  before do
    fs.reset_datadir
    fs.make_upstream_repo
  end

  # extract these into helper?
  def endpoint_for(attributes)
    Endpoint.new attributes
  end
  let(:repo)             { fs.upstream_repo_path }
  let(:ref)              { 'someref'             }
  let(:file)             { 'somefile'            }
  let(:owner)            { 'someowner'           }
  let(:webpath)          { 'somewebpath'         }
  let(:valid_attributes) {{repo: repo, ref: ref, file: file, owner: owner, webpath: webpath, datadir: datadir}}
  let(:endpoint)         { endpoint_for valid_attributes }

  describe '.retrieve' do
    def retrieve(endpoint)
      Endpoint.retrieve(endpoint)
    end

    it 'raises if there is no repo' do
      endpoint.repo = nil
      expect { retrieve endpoint }
        .to raise_error ArgumentError, /must have a repo/i
    end

    it 'raises if there is no fullpath' do
      endpoint.datadir = nil
      expect { retrieve endpoint }
        .to raise_error ArgumentError, /must have a fullpath/i
    end

    it 'clones the repo if the repo DNE' do
      retrieve endpoint
      fs.cd endpoint.fullpath do
        gitconfig = File.read('.git/config')
        expect(gitconfig).to match /remote.*?origin/
        expect(gitconfig).to include "url = #{endpoint.repo}"
      end
    end

    it 'does nothing if the repo already exists'
    it 'raises an error if there is a repo at the localpath, and it is the wrong one'
  end

  describe '#read' do

  end
end
