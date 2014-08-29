require 'sinatra/base'

class MiniatureOctoIronman < Sinatra::Base
  get '/lesson1' do
    markdown :lesson1
  end
end
