require 'sinatra/base'

class MiniatureOctoIronman < Sinatra::Base
  set :markdown, layout_engine: :haml, layout: :layout

  get '/lesson1' do
    markdown :lesson1#, :locals => { :text => markdown(:omg) }
  end

  get 'blog/:title' do
    @contents = Content.first(:type => 'blog', :alias => params[:title])
    @contents.body = RDiscount.new(@contents.body).to_html
    erb :blog_post
  end

end
