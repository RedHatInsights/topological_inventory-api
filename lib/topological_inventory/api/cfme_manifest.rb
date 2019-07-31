module TopologicalInventory
  module Api
    class CfmeManifest
      # Finds the manifest file that best matches the version supplied.
      # Looks for a full match first then iteratively checks for broader
      # and broader versions.
      #
      # e.g. 5.11.0.0 will check for 5_11_0_0, then 5_11_0, 5_11, then 5
      def self.find(version)
        parts = version.split(".")

        until parts.empty? || (manifest = manifest_by_version[parts.join("_")])
          parts.pop
        end

        manifest
      end

      private_class_method def self.manifest_by_version
        # List all manifests and cache the result to prevent a readdir on every API call
        @manifest_by_version ||=
          Pathname.glob(Rails.root.join("config", "cfme", "manifest_*.json")).index_by do |file|
            file.basename.to_s.match(/manifest_(.*)\.json/)[1]
          end
      end
    end
  end
end
