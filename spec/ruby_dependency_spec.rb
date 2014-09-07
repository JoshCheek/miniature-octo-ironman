require 'moi/ruby_dependency'

RSpec.describe 'Moi::RubyDependency' do
  def call(params)
    Moi::RubyDependency.call(params)
  end

  it 'chooses the RUBY_VERSION from the env when it satisfies the requirement' do
    %w[2 3 4].each do |current|
      chosen = call current: current, default: '1', requirement: '> 0'
      expect(chosen).to eq current
    end
  end

  it 'chooses the default when the current version does not satisfy the requirement' do
    chosen = call current: '2', default: '1', requirement: '= 1'
    expect(chosen).to eq '1'
  end

  it 'raises an error if the default does not satisfy the requirement' do
    expect { call current: '1', default: '1', requirement: '= 1' }
      .to_not raise_error

    expect { call current: '1', default: '2', requirement: '= 1' }
      .to raise_error Gem::DependencyError, /default/i
  end

  it 'errors when any key is missing' do
    expect { call current: '1', default: '1', requirement: '= 1' }.to_not raise_error

    expect { call               default: '1', requirement: '= 1' }.to     raise_error ArgumentError
    expect { call current: '1',               requirement: '= 1' }.to     raise_error ArgumentError
    expect { call current: '1', default: '1'                     }.to     raise_error ArgumentError

    expect { call current: nil, default: '1', requirement: '= 1' }.to     raise_error ArgumentError
    expect { call current: '1', default: nil, requirement: '= 1' }.to     raise_error ArgumentError
    expect { call current: '1', default: '1', requirement: nil   }.to     raise_error ArgumentError
  end
end
