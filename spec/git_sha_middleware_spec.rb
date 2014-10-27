require 'moi/git_sha_middleware'

RSpec.describe Moi::GitShaMiddleware do
  git_sha_header = 'Git-SHA' # pulled it out to make sure we don't accidentally get out of sync
  it "returns the app's code/headers/response, but adds in a #{git_sha_header} header, set to the provided SHA" do
    provided_env = Object.new
    received_env = nil
    app          = lambda { |env|
      received_env = env
      [123, {'omg' => 'wtf'}, ['bbq']]
    }

    returned = described_class.new(app, 'abc123').call(provided_env)

    expect(received_env).to equal provided_env
    expect(returned).to eq [123, {'omg' => 'wtf', git_sha_header => 'abc123'}, ['bbq']]
  end
end
