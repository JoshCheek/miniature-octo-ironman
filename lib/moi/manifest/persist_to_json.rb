require 'json'

module Moi
  class Manifest
    class PersistToJSON
      def initialize(file_path)
        @file_path = file_path
      end

      def save(manifest)
        File.write @file_path, manifest.map(&:to_hash).to_json
      end

      def load
        Moi::Manifest.new keys_to_sym(JSON.parse(File.read @file_path))
      end

      def keys_to_sym(hashes)
        hashes.map do |hash|
          Hash[hash.map { |key, value| [key.to_sym, value] }]
        end
      end
    end

  end
end
