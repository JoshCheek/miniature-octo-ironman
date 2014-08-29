require 'sinatra/base'

class MiniatureOctoIronman < Sinatra::Base
  set :markdown, layout_engine: :haml, layout: :layout

  get '/lesson1' do
    markdown :lesson1#, :locals => { :text => markdown(:omg) }
  end

  get '/omg' do
    markdown :omg
  end

end
