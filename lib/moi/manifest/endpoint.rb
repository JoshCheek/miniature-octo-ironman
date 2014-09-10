require 'pathname'
require 'rugged'

module Moi
  class Manifest
    class Endpoint
      ManifestError    = Class.new StandardError
      WatsGoinOnHere   = Class.new ManifestError
      MissingReference = Class.new ManifestError
      MissingFile      = Class.new ManifestError

      # TODO: renamings:
      #   repo     -> repo_path
      #   fullpath -> absolute_path
      #   file     -> main_filename

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
        elsif !fullpath.start_with?('/')
          "fullpath should be absolute, but it is #{fullpath.inspect}"
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


    class << Endpoint
      def retrieve(endpoint)
        endpoint.repo     or raise ArgumentError, "Must have a repo to retrieve, but #{endpoint.inspect} does not"
        endpoint.fullpath or raise ArgumentError, "Must have a fullpath to retrieve, but #{endpoint.inspect} does not"
        begin
          repo   = Rugged::Repository.new(endpoint.fullpath)
          remote = repo.remotes.find { |remote| remote.url == endpoint.repo }
          remote or raise Endpoint::WatsGoinOnHere, "Expected to have a remote for #{endpoint.repo.inspect}, but only had #{repo.remotes.map(&:url).inspect}"
        rescue Rugged::OSError
          Rugged::Repository.clone_at(endpoint.repo, endpoint.fullpath)
        rescue Rugged::RepositoryError => e
          raise Endpoint::WatsGoinOnHere, e.message
        end
      end

      def fetch_file(endpoint, filepath)
        retrieve endpoint
        repo = Rugged::Repository.new(endpoint.fullpath)
        endpoint_name = endpoint.ref

        branch = repo.branches
          .select(&:remote?)
          .find { |branch| branch.name.split("/").last == endpoint_name }
        if branch
          branch.remote.fetch
          endpoint_name = branch.name
        end

        commit = repo.rev_parse endpoint_name
        tree   = commit.tree
        path   = tree.path filepath
        blob   = repo.lookup path[:oid]
        blob.content
      rescue Rugged::ReferenceError
        raise Endpoint::MissingReference, "Couldn't find reference #{endpoint_name.inspect}"
      rescue Rugged::TreeError
        raise Endpoint::MissingFile, "Couldn't find the file #{filepath.inspect}"
      end
    end

  end
end
