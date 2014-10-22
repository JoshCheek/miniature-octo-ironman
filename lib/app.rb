require 'sinatra/base'
require 'redcarpet'
require 'haml'
require 'eval_in'
require 'moi'
require 'moi/manifest/persist_to_json'

Haml::Options.defaults[:ugly] = true

class MiniatureOctoIronman < Sinatra::Base
  # Thoughts:
  #   What if we save/load the manifest in a middleware?
  #   I think that would get us away from these singletons and hacks
  #   Could maybe also pass EvalIn in a middleware, and then in dev provide something that runs locally, and in prod something that actually hits EvalIn
  #
  #   Uhm... I also don't know how to tell what environment we're running in. There's probably some sort of sinatra "set :env, :test" or something, but haven't looked at it yet (this is a brain-dump)
  #
  #   UPDATE! - I didn't read my old thoughts, but there is now a middleware in config.ru and in the OurHelpers module,
  #             we can probably add this to each of those
  DATA_DIR  = File.expand_path "../../tmp/repos",         __FILE__
  JSON_FILE = File.expand_path "../../tmp/manifest.json", __FILE__

  Dir.mkdir File.dirname DATA_DIR unless Dir.exist? File.dirname DATA_DIR # <-- hack! I think this should just move into the manifest, not completely sure, but that should make it a lot more reliable (check the stupid before filter on the cukes)
  Dir.mkdir DATA_DIR              unless Dir.exist? DATA_DIR              # <-- hack!

  json_parser = Moi::Manifest::PersistToJSON.new JSON_FILE
  ENDPOINT_CONFIGURATION = json_parser.load

  set :markdown, layout_engine: :haml, layout: :layout

  get '/' do
    '<a href="/endpoints/new">Add an endpoint</a><br /><br />' +
    ENDPOINT_CONFIGURATION.map do |endpoint|
      path = [endpoint.owner, endpoint.webpath].join "/"
      "<a href=\"/#{path}\">#{path}</a>"
    end.join("<br>")
  end

  get '/run' do
    content_type :json
    env['eval_in'].call(params[:code],
                        language: 'ruby/mri-2.1',
                        context:  'https://github.com/JoshCheek/miniature-octo-ironman')
                  .to_json
  end

  # nearly the same as Endpoint::ATTRIBUTE_NAMES
  # there is also a test doing something simliar (it removes localpath, I think)
  # is there a good way to consolidate these?
  ATTRIBUTE_NAMES = [:repopath, :ref, :main_filename, :owner, :webpath].freeze

  get '/endpoints/new' do
    form = ATTRIBUTE_NAMES.collect { |attribute| "#{attribute}:<input type=\"text\" name=\"endpoint[#{attribute}]\"><br>" }.join
    '<form id="form_id" action="/endpoints" method="post">' + form +
    'test<textarea form="form_id" name = "endpoint[desc]", rows="6", cols="60"></textarea><br>
    <input type="submit" name="Submit">
    </form>'
  end

  post "/endpoints" do
    ENDPOINT_CONFIGURATION.add repopath:      params["endpoint"]["repopath"],
                               ref:           params["endpoint"]["ref"],
                               main_filename: params["endpoint"]["main_filename"],
                               owner:         params["endpoint"]["owner"],
                               webpath:       params["endpoint"]["webpath"],
                               datadir:       DATA_DIR
    json_parser.save(ENDPOINT_CONFIGURATION)
    "Got yah data!"
  end

  get '/:owner/:webpath' do
    endpoint = ENDPOINT_CONFIGURATION.find { |endpoint|
      endpoint.owner == params[:owner] &&
        endpoint.webpath == params[:webpath]
    }
    if endpoint
      headers["SHA-for-file"] = endpoint.ref
      markdown Moi::Manifest::Endpoint.fetch_file(endpoint)
    else
      redirect '/'
    end
  end
end
