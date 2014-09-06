require 'code_evaluator'

describe CodeEvaluator, "#run" do
  it "returns evaluated result" do
    code = 'puts "hello, world"'
    evaluator = CodeEvaluator.new(code)
    expect(evaluator.run).to eq({ "output"=>"hello, world\n" })
  end

  it "handles blank input" do
    code = ''
    evaluator = CodeEvaluator.new(code)
    expect(evaluator.run).to eq({ "output"=>"ERROR" })
  end

end
