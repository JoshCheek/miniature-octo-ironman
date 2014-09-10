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
  let(:ref)              { fs.current_sha fs.upstream_repo_path }
  let(:file)             { 'somefile'            }
  let(:owner)            { 'someowner'           }
  let(:webpath)          { 'somewebpath'         }
  let(:valid_attributes) {{repo: repo, ref: ref, file: file, owner: owner, webpath: webpath, datadir: datadir}}
  let(:endpoint)         { endpoint_for valid_attributes }

  def retrieve(endpoint)
    Endpoint.retrieve(endpoint)
  end

  def fetch_file(endpoint, filepath)
    Endpoint.fetch_file(endpoint, filepath)
  end

  describe '.retrieve' do
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

    it 'does nothing if the repo already exists' do
      retrieve endpoint
      retrieve endpoint
      cloned_sha   = fs.current_sha(endpoint.fullpath)
      upstream_sha = fs.current_sha(endpoint.repo)
      expect(cloned_sha).to eq upstream_sha
    end

    it 'raises an error if there is something at the localpath which is not a repository' do
      fs.mkdir(endpoint.fullpath)
      expect { retrieve endpoint }.to raise_error Endpoint::WatsGoinOnHere
    end

    it 'raises an error if there is a repo at the localpath, and it is the wrong one' do
      upstream_path = fs.make_upstream_repo(1)
      retrieve Endpoint.new(datadir: datadir, repo: upstream_path, localpath: endpoint.localpath)
      expect { retrieve endpoint }.to raise_error Endpoint::WatsGoinOnHere
    end
  end

  describe '#fetch_file(endpoint, filepath)' do
    # shitty to depend on 'somefile' and 'some content'
    # without seeing what they are and how they got that way,
    # can we get this passed into fs from the test instead?
    context 'when the ref is available' do
      it 'returns the file body' do
        retrieve endpoint
        content = fetch_file(endpoint, 'somefile')
        expect(content).to eq 'some content'
      end
    end

    context 'when the ref is not available' do
      it 'pulls to get the ref and returns the file body' do
        content = fetch_file(endpoint, 'somefile')
        expect(content).to eq 'some content'
      end
    end

    context 'when the ref is a branch' do
      # retrieve once
      # check sha
      # commit another file
      # fetch_file again
      # should get that body
      it 'always pulls, and then retuns the file body'
    end

    context 'edge cases' do
      example 'when there are multiple files' do
        fs.cd fs.upstream_repo_path do
          fs.write 'another-file', 'more-contents'
          fs.sh "git add ."
          fs.sh "git commit -m 'added another file'"
        end
        expect(fetch_file endpoint, 'another-file').to eq 'more-contents'
      end

      example 'when there are multiple versions', t:true do
        filename = 'somefile'
        fs.cd fs.upstream_repo_path do
          fs.write filename, 'contents-old'
          fs.sh 'git add .'
          fs.sh 'git commit -m "message-old"'
          fs.write filename, 'contents-new'
          fs.sh 'git add .'
          fs.sh 'git commit -m "message-new"'
        end
        sha_new, sha_old = fs.current_sha(fs.upstream_repo_path, 2)

        endpoint.ref = sha_old
        expect(fetch_file endpoint, filename).to eq 'contents-old'

        endpoint.ref = sha_new
        expect(fetch_file endpoint, filename).to eq 'contents-new'
      end
    end

    describe 'errors' do
      specify 'when the ref is not available'
      specify 'when the file is not available'
    end
  end
end
