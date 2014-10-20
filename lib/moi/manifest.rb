require 'moi/manifest/endpoint'

module Moi
  class Manifest
    attr_accessor :endpoints

    def initialize(endpoints_or_endpoint_hashes)
      self.endpoints = endpoints_or_endpoint_hashes.map do |endpoint_or_attributes|
        to_endpoint(endpoint_or_attributes)
      end
    end

    def size
      endpoints.size
    end

    def [](index)
      endpoints[index]
    end

    include Enumerable
    def each(&block)
      endpoints.each(&block)
    end

    def add(endpoint_or_attributes)
      endpoints << to_endpoint(endpoint_or_attributes)
    end

    private

    def to_endpoint(endpoint_or_attributes)
      Endpoint === endpoint_or_attributes ? endpoint_or_attributes : Endpoint.new(endpoint_or_attributes)
    end
  end
end
