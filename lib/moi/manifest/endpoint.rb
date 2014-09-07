module Moi
  class Manifest
    class Endpoint
      attr_accessor :repo, :ref, :file, :owner, :path, :localpath

      def initialize(attributes)
        missing = []
        init_attribute :repo,      attributes, missing
        init_attribute :ref,       attributes, missing
        init_attribute :file,      attributes, missing
        init_attribute :owner,     attributes, missing
        init_attribute :path,      attributes, missing
        init_attribute :localpath, attributes

        extra = attributes.keys - [:repo, :ref, :file, :owner, :path, :localpath]
        raise ArgumentError, "Extra attributes: #{extra.inspect}"     if extra.any?
        raise ArgumentError, "Missing attributes: #{missing.inspect}" if missing.any?
      end

      private

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
