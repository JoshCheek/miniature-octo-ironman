$LOAD_PATH << File.expand_path('lib', __dir__)
require 'app'

$stdout.puts "PROD ENV LOADED"

require 'moi/git_sha_middleware'
use Moi::GitShaMiddleware, `git log -1 --pretty=format:"%H"`.chomp.freeze

# add rack middleware to inject the development EvalIn
require 'eval_in'
use Class.new {
  def initialize(app)
    @app = app
  end

  def inspect
    "#<Middleware that injects prod EvalIn (defined in:#{__FILE__.inspect})>"
  end

  def call(env)
    env['eval_in'] = EvalIn
    @app.call(env)
  end
}

run MiniatureOctoIronman
