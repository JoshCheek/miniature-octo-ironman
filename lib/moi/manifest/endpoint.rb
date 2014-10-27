require 'pathname'
require 'rugged'

module Moi
  class Manifest
    class Endpoint
      ManifestError    = Class.new StandardError
      WatsGoinOnHere   = Class.new ManifestError
      MissingReference = Class.new ManifestError
      MissingFile      = Class.new ManifestError

      ATTRIBUTE_NAMES = [:repopath, :ref, :main_filename, :owner, :webpath, :localpath, :datadir].freeze
      attr_accessor *ATTRIBUTE_NAMES

      def initialize(attributes)
        extras = attributes.keys - ATTRIBUTE_NAMES
        raise ArgumentError, "Wat are these? #{extras.inspect}" if extras.any?
        ATTRIBUTE_NAMES.each { |attribute| self.__send__ "#{attribute}=", attributes[attribute] }
      end

      def absolute_path
        File.join(datadir, localpath) if datadir && localpath
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
        elsif !absolute_path.start_with?('/')
          "absolute_path should be absolute, but it is #{absolute_path.inspect}"
        end
      end

      def to_hash
        {repopath: repopath,
         ref: ref,
         main_filename: main_filename,
         owner: owner,
         webpath: webpath,
         localpath: localpath,
         datadir: datadir
        }
      end

      private

      def reponame
        Pathname.new(repopath).basename.sub_ext("") if repopath
      end

      def generate_localpath
        File.join(owner, reponame) if owner && reponame
      end
    end
  end
end
