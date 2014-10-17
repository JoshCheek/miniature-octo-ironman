require 'sinatra/base'
require 'redcarpet'
require 'haml'
require 'eval_in'
require 'moi'

Haml::Options.defaults[:ugly] = true

class MiniatureOctoIronman < Sinatra::Base
  # Thoughts:
  #   What if we save/load the manifest in a middleware?
  #   I think that would get us away from these singletons and hacks
  #   Could maybe also pass EvalIn in a middleware, and then in dev provide something that runs locally, and in prod something that actually hits EvalIn
  #
  #   Uhm... I also don't know how to tell what environment we're running in. There's probably some sort of sinatra "set :env, :test" or something, but haven't looked at it yet (this is a brain-dump)
  ENDPOINT_CONFIGURATION = Moi::Manifest.new []
  DATA_DIR = File.expand_path("../../tmp/repos", __FILE__).freeze
  Dir.mkdir File.dirname DATA_DIR unless Dir.exist? File.dirname DATA_DIR # <-- hack!
  Dir.mkdir DATA_DIR              unless Dir.exist? DATA_DIR              # <-- hack!

  set :markdown, layout_engine: :haml, layout: :layout

  get '/' do
    ENDPOINT_CONFIGURATION.map do |endpoint|
      path = [endpoint.owner, endpoint.webpath].join "/"
      "<a href=\"/#{path}\">#{path}</a>"
    end.join "<br>"
  end

  get '/run' do
    content_type :json
    EvalIn.call(params[:code], language: 'ruby/mri-2.1', context: 'https://github.com/JoshCheek/miniature-octo-ironman')
          .to_json
    # -- for playing around without constantly hitting https://eval.in --
    # EvalIn::Result.new(
    #   exitstatus:        0,
    #   language:          "ruby/mri-2.1",
    #   language_friendly: "Ruby — MRI 2.1",
    #   code:              "\n  puts ['a', 'b', 'c'].size\n",
    #   output:            "mock-from-run\n",
    #   status:            "OK (0.052 sec real, 0.059 sec wall, 9 MB, 18 syscalls)",
    #   url:               "https://eval.in/189558.json"
    # ).to_json
  end

  # nearly the same as Endpoint::ATTRIBUTE_NAMES
  # there is also a test doing something simliar (it removes localpath, I think)
  # is there a good way to consolidate these?
  ATTRIBUTE_NAMES = [:repopath, :ref, :main_filename, :owner, :webpath].freeze 

  get '/endpoints/new' do
    form = ATTRIBUTE_NAMES.collect { |attribute| "#{attribute}:<input type=\"text\" name=\"endpoint[#{attribute}]\"><br>" }.join
    '<form id="form_id" action="/endpoints" method="post">' + form +
    'test<textarea form="form_id" name = "endpoint[desc]", rows="6", cols="60"></textarea><br>
    <input type="submit" name="Submit">
    </form>'
  end

  post "/endpoints" do
    ENDPOINT_CONFIGURATION.add repopath:      params["endpoint"]["repopath"],
                               ref:           params["endpoint"]["ref"],
                               main_filename: params["endpoint"]["main_filename"],
                               owner:         params["endpoint"]["owner"],
                               webpath:       params["endpoint"]["webpath"],
                               datadir:       DATA_DIR
    "Got yah data!"
  end

  get '/:owner/:webpath' do
    endpoint = ENDPOINT_CONFIGURATION.find { |endpoint|
      endpoint.owner == params[:owner] &&
        endpoint.webpath == params[:webpath]
    }
    if endpoint
      headers["SHA-for-file"] = endpoint.ref
      markdown Moi::Manifest::Endpoint.fetch_file(endpoint, endpoint.main_filename)
    else
      redirect '/'
    end
  end
end
