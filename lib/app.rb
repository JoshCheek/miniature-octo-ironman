require 'sinatra/base'
require 'redcarpet'
require 'haml'
require 'eval_in'
require 'moi'

Haml::Options.defaults[:ugly] = true

class MiniatureOctoIronman < Sinatra::Base
  ENDPOINT_CONFIGURATION = Moi::Manifest.new []
  DATA_DIR = File.expand_path "../../tmp/repos", __FILE__
  Dir.mkdir DATA_DIR unless Dir.exist? DATA_DIR # <-- hack!

  set :markdown, layout_engine: :haml, layout: :layout

  get '/' do
    ENDPOINT_CONFIGURATION.map do |endpoint|
      path = [endpoint.owner, endpoint.webpath].join "/"
      "<a href=\"/#{path}\">#{path}</a>"
    end.join "<br>"
  end

  get '/lesson1' do
    markdown :lesson1
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

  ATTRIBUTE_NAMES = [:repopath, :ref, :main_filename, :owner, :webpath].freeze
  get '/endpoints/new' do
    form = ATTRIBUTE_NAMES.collect { |attribute| "#{attribute}:<input type=\"text\" name=\"endpoint[#{attribute}]\"><br>" }.join
    '<form id="form_id" action="/endpoints" method="post">' + form +
    '<input type="submit" name="Submit">
    </form>'

  end

  post "/endpoints" do
  endpoint_args = {repopath:      params["endpoint"]["repopath"],
                   ref:           params["endpoint"]["ref"],
                   main_filename: params["endpoint"]["main_filename"],
                   owner:         params["endpoint"]["owner"],
                   webpath:       params["endpoint"]["webpath"],
                   datadir:       DATA_DIR
                   }
    ENDPOINT_CONFIGURATION.add endpoint_args
    "Got yah data!"
  end

  get '/:owner/:webpath' do
    endpoint = ENDPOINT_CONFIGURATION.find { |endpoint|
      endpoint.owner == params[:owner] &&
        endpoint.webpath == params[:webpath]
    }
    if endpoint
      headers["SHA-for-file"] = endpoint.ref
      markdown Moi::Manifest::Endpoint.fetch_file(
        endpoint,
        endpoint.main_filename,
      )
    else
      redirect '/'
      # raise "couldn't find an endpoint for owner: #{params[:owner]} and webpath: #{params[:webpath]}"
    end
  end
end
