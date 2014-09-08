require 'pathname'

module Moi
  class Manifest
    class Endpoint
      ATTRIBUTE_NAMES = [:repo, :ref, :file, :owner, :webpath, :localpath, :datadir].freeze
      attr_accessor *ATTRIBUTE_NAMES

      def initialize(attributes)
        extras = attributes.keys - ATTRIBUTE_NAMES
        raise ArgumentError, "Wat are these? #{extras.inspect}" if extras.any?
        ATTRIBUTE_NAMES.each { |attribute| self.__send__ "#{attribute}=", attributes[attribute] }
      end

      def fullpath
        datadir && localpath && File.join(datadir, localpath)
      end

      def localpath
        @localpath || generate_localpath
      end

      def valid?
        !error
      end

      def error # should prob do this dynamically
        missing = ATTRIBUTE_NAMES.reject { |n| __send__ n }
        if missing.any?
          "Missing attributes: #{missing.inspect}"
        elsif localpath && localpath.start_with?("/")
          "localpath should not be absolute, but it is #{localpath.inspect}"
        end
      end

      private

      def reponame
        repo && Pathname.new(repo).basename.sub_ext("")
      end

      def generate_localpath
        owner && reponame && File.join(owner, reponame)
      end
    end
  end
end
