require 'moi/manifest'

RSpec.describe 'Moi::Manifest::Endpoint' do
  def endpoint_for(attributes)
    Moi::Manifest::Endpoint.new attributes
  end
  let(:reponame)         { 'miniature-octo-ironman'                       }

  let(:repopath)         { "https://github.com/JoshCheek/#{reponame}.git" }
  let(:ref)              { 'someref'                                      }
  let(:main_filename)    { 'somefile'                                     }
  let(:owner)            { 'someowner'                                    }
  let(:webpath)          { 'somewebpath'                                  }
  let(:datadir)          { '/somedatadir'                                 }
  let(:valid_attributes) {{repopath: repopath, ref: ref, main_filename: main_filename, owner: owner, webpath: webpath, datadir: datadir}}
  let(:endpoint)         { endpoint_for valid_attributes }

  it 'has a git repopath, ref, main_filename, owner, datadir, and webpath' do
    expect(endpoint.repopath     ).to eq repopath
    expect(endpoint.ref          ).to eq ref
    expect(endpoint.main_filename).to eq main_filename
    expect(endpoint.owner        ).to eq owner
    expect(endpoint.webpath      ).to eq webpath
    expect(endpoint.datadir      ).to eq datadir
  end

  describe '#localpath/#absolute_path' do
    context 'when there is not a localpath' do
      it 'chooses a localpath of the_owner/reponame, within the datadir' do
        expect(endpoint.absolute_path).to  eq "#{datadir}/#{owner}/#{reponame}"
        expect(endpoint.localpath).to eq "#{owner}/#{reponame}"
      end
    end

    context 'when there is a localpath' do
      it 'respects the localpath, but still assumes it is within the datadir' do
        endpoint.localpath = "a/b/c"
        expect(endpoint.absolute_path).to  eq "#{datadir}/a/b/c"
        expect(endpoint.localpath).to eq "a/b/c"
      end
    end

    context 'when there is not a datadir' do
      before { endpoint.datadir = nil }

      it 'chooses a localpath of the_owner/reponame' do
        expect(endpoint.localpath).to eq "#{owner}/#{reponame}"
      end

      it 'has no absolute_path' do
        expect(endpoint.absolute_path).to eq nil
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
      [:repopath, :ref, :main_filename, :owner, :webpath, :datadir].each do |attribute|
        invalid_attributs = valid_attributes.reject { |k, v| k == attribute }
        yield attribute, endpoint_for(invalid_attributs)
      end
    end

    it 'is invalid if there is an error string' do
      expect(endpoint_for valid_attributes).to be_valid

      missing_attr, endpoint = each_invalid.first
      expect(endpoint).to_not be_valid
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
      expect(endpoint.error).to match /localpath/
    end

    it 'is invalid if absolute_path is not absolute' do
      endpoint = endpoint_for valid_attributes.merge(datadir: 'a')
      expect(endpoint).to_not be_valid
      expect(endpoint.error).to match /absolute_path/
    end
  end
end
