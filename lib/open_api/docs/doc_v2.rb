module OpenApi
  class Docs
    class DocV2
      attr_reader :content

      def initialize(content)
        @content = content
      end

      def version
        @version ||= Gem::Version.new(content.fetch_path("info", "version"))
      end

      def definitions
        @definitions ||= content["definitions"]
      end

      def example_attributes(key)
        definitions[key]["properties"].each_with_object({}) do |(col, stuff), hash|
          hash[col] = stuff["example"] if stuff.key?("example")
        end
      end
    end
  end
end
