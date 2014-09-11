require 'sinatra/base'
require 'redcarpet'
require 'haml'
require 'eval_in'
require 'moi'

Haml::Options.defaults[:ugly] = true

class MiniatureOctoIronman < Sinatra::Base
  ENDPOINT_CONFIGURATION = Moi::Manifest.new []

  set :markdown, layout_engine: :haml, layout: :layout

  get '/' do
    "please go to localhost:somenumber/lesson1"
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

  get '/:owner/:webpath' do
    endpoint = ENDPOINT_CONFIGURATION.find { |endpoint|
      endpoint.owner == params[:owner] &&
        endpoint.webpath == params[:webpath]
    }
    markdown Moi::Manifest::Endpoint.fetch_file(
      endpoint,
      endpoint.file,
    )
  end
end
