require 'rubygems/version'
require 'rubygems/requirement'

class Moi
  class RubyDependency

    # @example
    #   Moi::RubyDependency.call requirement: '~> 2.1.0',
    #                            default:     '2.1.2',
    #                            current:     RUBY_VERSION
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params
    end

    def call
      default_must_satisfy_requirement!
      requirement.satisfied_by?(current) ? current.version
                                         : default.version
    end

    private

    def requirement
      @requirement ||= Gem::Requirement.new fetch(:requirement)
    end

    def default
      @default ||= Gem::Version.new fetch(:default)
    end

    def current
      @current ||= Gem::Version.new fetch(:current)
    end

    def fetch(key)
      return @params[key] if @params[key]
      raise ArgumentError, "#{@params.inspect} does not have key #{key.inspect}"
    end

    def default_must_satisfy_requirement!
      requirement.satisfied_by?(default) or
        raise Gem::DependencyError, "Default (#{default}) does not satisfy requirement (#{requirement})"
    end
  end
end

