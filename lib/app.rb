require 'sinatra/base'
require 'redcarpet'
require 'haml'

Haml::Options.defaults[:ugly] = true

class MiniatureOctoIronman < Sinatra::Base
  set :markdown, layout_engine: :haml, layout: :layout

  get '/' do
    "please go to localhost:somenumber/lesson1"
  end

  get '/lesson1' do
    markdown :lesson1
  end
end
