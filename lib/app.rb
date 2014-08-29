require 'sinatra/base'

class MiniatureOctoIronman < Sinatra::Base
  get '/lesson1' do
    "Lesson 1"
  end
end
