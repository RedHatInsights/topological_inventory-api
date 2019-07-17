module TopologicalInventory
  module Api
    class CfmeManifest
      def self.find(version)
        version.gsub!(".", "_")

        manifest = nil
        until version.blank? || (manifest = manifest_by_version[version]).present?
          version = version.split("_")[0...-1].join("_")
        end

        manifest
      end

      private_class_method def self.manifest_by_version
        @manifest_by_version ||= Pathname.glob(Rails.root.join("config", "cfme", "manifest_*.json")).index_by do |file|
          file.basename.to_s.match(/manifest_(.*)\.json/)[1]
        end
      end
    end
  end
end
