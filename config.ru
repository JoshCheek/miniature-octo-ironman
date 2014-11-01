$LOAD_PATH << File.expand_path('lib', __dir__)
require 'app'

# add rack middleware to inject the development EvalIn
require 'pp'
require 'eval_in/mock'
require 'moi/git_sha_middleware'

# https://github.com/rack/rack/blob/master/lib/rack/logger.rb
# http://www.rubydoc.info/stdlib/logger/Logger
# setting log level to debug, b/c we're in dev, so just print as much shit as we can
# (unless it gets spammy, then we'll turn it off. Default is IFNO)
use Rack::Logger, Logger::DEBUG

use Moi::GitShaMiddleware, `git log -1 --pretty=format:"%H"`.chomp.freeze
use Class.new {
  def initialize(app)
    @app = app
  end

  def inspect
    "#<Middleware that injects dev EvalIn (defined in:#{__FILE__.inspect}), can evaluate #{languages.keys.inspect}>"
  end

  def call(env)
    json_file_location = File.expand_path "../tmp/manifest.json", __FILE__
    env['eval_in'] = eval_in_that_logs_and_evaluates(env['rack.logger'])
    env['json_parser'] = Moi::Manifest::PersistToJSON.new json_file_location
    env['manifest'] = env['json_parser'].load
    @app.call(env)
  end

  private

  def languages
    { 'ruby/mri-2.1' => {program: RbConfig.ruby, args: []},
    }
  end

  def eval_in_that_logs_and_evaluates(logger)
    EvalIn::Mock.new on_call: handle_call(logger)
  end

  def handle_call(logger)
    lambda do |code, options|
      logger.debug "EvalIn\n"\
                   "  options: #{options.inspect}\n"\
                   "  code:    #{code.inspect}"
      EvalIn::Mock.new(languages: languages)
                  .call(code, options)
                  .tap { |result| logger.info "EvalIn result:\n#{indent(pretty_inspect result)}" }
    end
  end

  def indent(string)
    string.gsub(/^/, '  ')
  end

  def pretty_inspect(obj)
    PP.pp obj, '', 74
  end
}

run MiniatureOctoIronman
