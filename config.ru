$LOAD_PATH << File.expand_path('lib', __dir__)
require 'app'

# add rack middleware to inject the development EvalIn
require 'pp'
require 'eval_in/mock'
use Class.new {
  def initialize(app)
    @app = app
  end

  def inspect
    "#<Middleware that injects dev EvalIn (defined in:#{__FILE__.inspect}), can evaluate #{languages.keys.inspect}>"
  end

  def call(env)
    env['eval_in'] = eval_in_that_logs_and_evaluates
    @app.call(env)
  end

  private

  def languages
    { 'ruby/mri-2.1' => {program: 'ruby', args: []},
    }
  end

  # is there a logger I can pull off of the env or the app or something,
  # instead of talking directly to stdout?
  def eval_in_that_logs_and_evaluates
    handle_call = lambda do |code, options|
      $stdout.puts "EvalIn evaluating code:", indent(code)
      EvalIn::Mock.new(languages: languages)
                  .call(code, options)
                  .tap { |result| $stdout.puts "EvalIn result:", indent(pretty_inspect result) }
    end
    EvalIn::Mock.new on_call: handle_call
  end

  def indent(string)
    string.gsub(/^/, '  ')
  end

  def pretty_inspect(obj)
    PP.pp obj, '', 74
  end
}

run MiniatureOctoIronman
