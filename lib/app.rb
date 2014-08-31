require 'sinatra/base'

class MiniatureOctoIronman < Sinatra::Base
  set :markdown, layout_engine: :haml, layout: :layout

  get '/lesson1' do
    markdown :lesson1
  end

  get '/editor' do
    erb :editor
  end

end
