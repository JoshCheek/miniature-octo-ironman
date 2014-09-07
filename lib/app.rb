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

  get '/run' do
    EvalIn.call(params[:code],
                context: 'https://github.com/JoshCheek/miniature-octo-ironman',
                language: 'ruby/mri-2.1')
          .to_json
  end
end
