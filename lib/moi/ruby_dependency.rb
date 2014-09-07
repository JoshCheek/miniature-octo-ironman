require 'rubygems/version'
require 'rubygems/requirement'

class Moi
  module RubyDependency
    # @example
    #   Moi::RubyDependency.call requirement: '~> 2.1.0',
    #                            default:     '2.1.2,
    #                            current:     RUBY_VERSION
    def self.call(params)
      requirement = Gem::Requirement.new fetch(params, :requirement)
      default     = Gem::Version.new     fetch(params, :default)
      current     = Gem::Version.new     fetch(params, :current)

      requirement.satisfied_by?(default) or
        raise Gem::DependencyError, "Default (#{default}) does not satisfy requirement (#{requirement})"

      (requirement.satisfied_by?(current) ? current : default).version
    end

    private

    def self.fetch(params, key)
      params[key] or
        raise ArgumentError, "#{params.inspect} does not have key #{key.inspect}"
    end
  end
end

