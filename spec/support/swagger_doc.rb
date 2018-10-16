module Spec
  module Support
    class SwaggerDocs
      attr_reader :docs

      def initialize
        @docs ||= {}

        Rails.root.join("public/doc/").each_child do |path|
          next unless path.file?

          swagger_doc = SwaggerDoc.new(path)
          raise "Version #{swagger_doc.version_string} already loaded!" if docs[swagger_doc.version_string]
          @docs[swagger_doc.version_string] = swagger_doc
        end
      end

      def routes
        @routes ||= begin
          docs.each_with_object([]) do |(_version, doc), routes|
            routes.concat(doc.routes)
          end
        end
      end
    end

    class SwaggerDoc
      attr_reader :content, :filename

      def initialize(path)
        @filename = path.to_s
        @path = path
        require 'yaml'
        @content = YAML.load_file(@path)

        raise "Not a valid swagger doc" unless @content["swagger"]
      end

      def version_string
        @version_string ||= content.fetch_path("info", "version")
      end

      def base_path
        @base_path ||= content["basePath"]
      end

      def paths
        content["paths"]
      end

      def routes
        @routes ||= begin
          paths.flat_map do |path, hash|
            hash.collect do |verb, _details|
              p = File.join(base_path, path).gsub(/{\w*}/, ":id")
              {:path => p, :verb => verb.upcase}
            end
          end
        end
      end
    end
  end
end
