require 'eval_in'
require 'pathname'

class CodeEvaluator
  attr_reader :code

  def initialize(code)
    @code = code
  end

  def run
    {"output" => fetch_results}
  end

private

  def fetch_results
    result = EvalIn.call(code, language: 'ruby/mri-2.1')
    result.output

  rescue StandardError => e
    'ERROR'
  end

end
