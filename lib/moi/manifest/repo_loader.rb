module Moi
  class Manifest
    module RepoLoader
      class << self
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

        def fetch_file(endpoint, filepath = endpoint.main_filename)
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
end
