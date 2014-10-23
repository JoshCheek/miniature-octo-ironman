require 'app'
require 'fileutils'
require 'eval_in/mock'

require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist

# TODO: a certain amount of FileUtils usage
# that we could pull into fshelpers
module OurHelpers
  class << self
    attr_accessor :server_thread
  end

  extend self

  # uhm, should these only be class methods?
  # not really liking how these objects get all confused and shit
  attr_accessor :app
  def start_server
    OurHelpers.server_thread = Thread.new {
      OurHelpers.app = build_app
      Rack::Server.start Port: 1235, server: 'puma', app: OurHelpers.app
    }
  end

  def stop_server
    OurHelpers.server_thread && OurHelpers.server_thread.kill
  end

  def internet
    @internet ||= Capybara.current_session
  end

  def editor_class
    '.interactive-code.ace_editor'
  end

  def displayed_result_class
    '.result-display'
  end

  require_relative '../../spec/spec_helper'
  def file_helper
    @file_helper ||= FsHelpers.new File.expand_path('../../../tmp', __FILE__)
  end

  require 'moi/manifest/endpoint'
  def endpoint
    Moi::Manifest::Endpoint.new(
      repopath:      file_helper.upstream_repo_path,
      ref:           file_helper.current_sha(file_helper.upstream_repo_path),
      main_filename: 'somefile',
      owner:         'someowner',
      webpath:       'custom_lesson',
      datadir:       MiniatureOctoIronman::DATA_DIR,
    )
  end

  # So we can use these inside of our tests, maybe there is a better way to?
  # I'm not sure of what else we can do at the moment, but something to consider
  attr_accessor :manifest, :json_parser, :json_file_location
  def create_objects
    @json_file_location = File.expand_path "../../../tmp/manifest.json", __FILE__
    @json_parser = Moi::Manifest::PersistToJSON.new json_file_location
    @manifest = json_parser.load
  end

  # A middleware to mock out any of our dev/prod middlewares
  # Currently it only injects eval_in key into the env
  def build_app
    create_objects
    middleware = Struct.new(:app, :parser, :manifest) {
      def inspect
        "#<Middleware for test environment (defined in: #{__FILE__.inspect})>"
      end

      attr_accessor :next_eval_in_response
      def call(env)
        env['json_parser'] = parser
        env['manifest'] = manifest
        app.call(env.merge 'eval_in' => mock_eval_in)
      end

      def mock_eval_in
        EvalIn::Mock.new(on_call: lambda { |code, options|
          next_eval_in_response ||
            raise("Need to set an eval_in response before calling it!")
        })
      end
    }
    middleware.new(MiniatureOctoIronman, json_parser, manifest)
  end
end
