require 'app'
require 'fileutils'

require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist

# TODO: a certain amount of FileUtils usage
# that we could pull into fshelpers
module OurHelpers
  class << self
    attr_accessor :server_thread
  end

  extend self

  def views_dir
    @views_dir ||= begin
      dir = File.expand_path '../../../tmp', __FILE__
      FileUtils.mkdir_p dir
      dir
    end
  end

  def copy_views
    root_path = File.expand_path '../../..', __FILE__

    view_files = Dir[root_path +"/lib/views/*"]

    view_files.each do |view_file|
     filename = File.basename view_file
     FileUtils.cp view_file, path_to_view(filename)
    end
  end

  def path_to_view(name)
    File.join views_dir, name
  end

  def server
    MiniatureOctoIronman
  end

  def internet
    @internet ||= Capybara.current_session
  end

  def start_server
    OurHelpers.server_thread = Thread.new {
      Rack::Server.start app: OurHelpers.server.new, Port: 1235, server: 'puma'
    }
  end

  def stop_server
    OurHelpers.server_thread && OurHelpers.server_thread.kill
  end

  def editor_class
    '.interactive-code.ace_editor'
  end

  def displayed_result_class
    '.result-display'
  end

  require_relative '../../spec/spec_helper'
  def file_helper
    @file_helper ||= FsHelpers.new File.expand_path('../../tmp', __FILE__)
  end

  require 'moi/manifest/endpoint'
  def endpoint
    Moi::Manifest::Endpoint.new(
      repopath:      file_helper.upstream_repo_path,
      ref:           file_helper.current_sha(file_helper.upstream_repo_path),
      main_filename: 'somefile',
      owner:         'someowner',
      webpath:       'custom_lesson',
      datadir:       file_helper.datadir,
    )
  end
end
