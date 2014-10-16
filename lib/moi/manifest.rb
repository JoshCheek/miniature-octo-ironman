require 'moi/manifest/endpoint'

module Moi
  class Manifest
    attr_accessor :endpoints

    def initialize(endpoints_or_endpoint_hashes)
      self.endpoints = []
      endpoints_or_endpoint_hashes.each do |endpoint_or_attributes|
        add(endpoint_or_attributes)
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
      endpoint = Endpoint === endpoint_or_attributes ? endpoint_or_attributes : Endpoint.new(endpoint_or_attributes)
      self.endpoints << endpoint
    end

  end
end
