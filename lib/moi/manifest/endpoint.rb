module Moi
  class Manifest
    class Endpoint
      attr_accessor :repo, :ref, :file, :owner, :path, :localpath

      def initialize(attributes)
        self.extra   = attributes.keys - [:repo, :ref, :file, :owner, :path, :localpath]
        self.missing = []
        init_attribute :repo,      attributes, missing
        init_attribute :ref,       attributes, missing
        init_attribute :file,      attributes, missing
        init_attribute :owner,     attributes, missing
        init_attribute :path,      attributes, missing
        init_attribute :localpath, attributes
      end

      def valid?
        !error
      end

      def error
        if missing.any?
          "Missing attributes: #{missing.inspect}"
        elsif extra.any?
          "Extra attributes: #{extra.inspect}"
        end
      end

      private

      attr_accessor :missing, :extra

      def init_attribute(name, attributes, missing=nil)
        if attributes[name]
          self.__send__ "#{name}=", attributes[name]
        elsif missing
          missing << name
        end
      end
    end
  end
end
