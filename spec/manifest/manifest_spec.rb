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

  describe 'Moi::Manifest::Endpoint' do
    let(:reponame)         { 'miniature-octo-ironman'                       }

    let(:repo)             { "https://github.com/JoshCheek/#{reponame}.git" }
    let(:ref)              { 'someref'                                      }
    let(:file)             { 'somefile'                                     }
    let(:owner)            { 'someowner'                                    }
    let(:webpath)          { 'somewebpath'                                  }
    let(:datadir)          { 'somedatadir'                                  }
    let(:valid_attributes) {{repo: repo, ref: ref, file: file, owner: owner, webpath: webpath, datadir: datadir}}
    let(:endpoint)         { endpoint_for valid_attributes }

    it 'has a git repo, ref, file, owner, datadir, and webpath' do
      expect(endpoint.repo   ).to eq repo
      expect(endpoint.ref    ).to eq ref
      expect(endpoint.file   ).to eq file
      expect(endpoint.owner  ).to eq owner
      expect(endpoint.webpath).to eq webpath
      expect(endpoint.datadir).to eq datadir
    end

    describe '#localpath/#fullpath' do
      context 'when there is not a localpath' do
        it 'chooses a localpath of the_owner/reponame, within the datadir' do
          expect(endpoint.fullpath).to  eq "#{datadir}/#{owner}/#{reponame}"
          expect(endpoint.localpath).to eq "#{owner}/#{reponame}"
        end
      end

      context 'when there is a localpath' do
        it 'respects the localpath, but still assumes it is within the datadir' do
          endpoint.localpath = "a/b/c"
          expect(endpoint.fullpath).to  eq "#{datadir}/a/b/c"
          expect(endpoint.localpath).to eq "a/b/c"
        end
      end

      context 'when there is not a datadir' do
        before { endpoint.datadir = nil }

        it 'chooses a localpath of the_owner/reponame' do
          expect(endpoint.localpath).to eq "#{owner}/#{reponame}"
        end

        it 'has no fullpath' do
          expect(endpoint.fullpath).to eq nil
        end
      end
    end

    it 'raises an error if initialized with extra attributes (presumably you fucked something up somewhere)' do
      expect { endpoint_for valid_attributes.merge(extra: 'val') }
        .to raise_error ArgumentError, /extra/
    end

    context 'validation/errors' do
      def each_invalid
        return to_enum :each_invalid unless block_given?
        [:repo, :ref, :file, :owner, :webpath, :datadir].each do |attribute|
          invalid_attributs = valid_attributes.reject { |k, v| k == attribute }
          yield attribute, endpoint_for(invalid_attributs)
        end
      end

      xit 'is invalid if there is an error string' do
        expect(endpoint_for valid_attributes).to be_valid
        expect(endpoint_for each_invalid.first).to_not be_valid
      end

      it 'has a nil error string when all attributes are available' do
        expect(endpoint_for(valid_attributes).error).to be_nil
        expect(endpoint_for(valid_attributes.merge(localpath: 'somepath')).error).to be_nil
      end

      it 'has an error string that explains what keys are missing' do
        each_invalid do |attribute, endpoint|
          expect(endpoint.error).to match /Missing attributes: .*?#{attribute}/
        end
      end

      it 'is invalid with error if localpath is absolute' do
        endpoint = endpoint_for valid_attributes.merge(localpath: "/a")
        expect(endpoint).to_not be_valid
        expect(endpoint.error).to match /absolute/
      end
    end
  end
end
