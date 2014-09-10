require 'sinatra/base'
require 'redcarpet'
require 'haml'
require 'eval_in'

Haml::Options.defaults[:ugly] = true

class MiniatureOctoIronman < Sinatra::Base
  set :markdown, layout_engine: :haml, layout: :layout

  get '/' do
    "please go to localhost:somenumber/lesson1"
  end

  get '/lesson1' do
    markdown :lesson1
  end

  get '/custom_lesson' do
    Moi::Manifest.new(MiniatureOctoIronman::ENDPOINT_CONFIGURATION)
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
end
