require 'pathname'

module Moi
  class Manifest
    class Endpoint
      attr_accessor :repo, :ref, :file, :owner, :webpath, :datadir

      def initialize(attributes)
        self.extra   = attributes.keys - [:repo, :ref, :file, :owner, :webpath, :localpath, :datadir]
        self.missing = []
        init_attribute :repo,      attributes, missing
        init_attribute :ref,       attributes, missing
        init_attribute :file,      attributes, missing
        init_attribute :owner,     attributes, missing
        init_attribute :webpath,   attributes, missing
        init_attribute :datadir,   attributes, missing
        init_attribute :localpath, attributes
      end

      attr_writer :localpath

      def fullpath
        datadir && File.join(datadir, localpath)
      end

      def localpath
        @localpath || File.join(owner, reponame)
      end

      def valid?
        !error
      end

      def error # should prob do this dynamically
        if missing.any?
          "Missing attributes: #{missing.inspect}"
        elsif extra.any?
          "Extra attributes: #{extra.inspect}"
        elsif localpath && localpath.start_with?("/")
          "localpath should not be absolute, but it is #{localpath.inspect}"
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

      def reponame
        Pathname.new(repo).basename.sub_ext("")
      end
    end
  end
end
