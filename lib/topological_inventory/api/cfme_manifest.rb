module TopologicalInventory
  module Api
    class CfmeManifest
      def self.find(version)
        version.gsub!(".", "_")

        # Find the manifest file that best matches the version supplied.
        # Look for a full match first then iteratively check for broader
        # and broader versions.
        #
        # E.g. 5.11.0.0 will check for 5.11.0.0, then 5.11.0, 5.11, then 5
        until version.blank? || (manifest = manifest_by_version[version]).present?
          version = version.split("_")[0...-1].join("_")
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
