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
        repopath && Pathname.new(repopath).basename.sub_ext("")
      end

      def generate_localpath
        owner && reponame && File.join(owner, reponame)
      end
    end


    class << Endpoint
      def retrieve(endpoint)
        endpoint.repopath      or raise ArgumentError, "Must have a repopath to retrieve, but #{endpoint.inspect} does not"
        endpoint.absolute_path or raise ArgumentError, "Must have a absolute path to retrieve, but #{endpoint.inspect} does not"
        begin
          repo   = Rugged::Repository.new(endpoint.absolute_path)
          remote = repo.remotes.find { |remote| remote.url == endpoint.repopath }
          remote or raise Endpoint::WatsGoinOnHere, "Expected to have a remote for #{endpoint.repopath.inspect}, but only had #{repo.remotes.map(&:url).inspect}"
        rescue Rugged::OSError
          Rugged::Repository.clone_at(endpoint.repopath, endpoint.absolute_path)
        rescue Rugged::RepositoryError => e
          raise Endpoint::WatsGoinOnHere, e.message
        end
      end

      def fetch_file(endpoint, filepath)
        retrieve endpoint
        repo = Rugged::Repository.new(endpoint.absolute_path)
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
        raise Endpoint::MissingFile, "Couldn't find the main_filename #{filepath.inspect}"
      end
    end

  end
end
