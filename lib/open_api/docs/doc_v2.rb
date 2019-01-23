module OpenApi
  class Docs
    class DocV2
      attr_reader :content

      def initialize(content)
        @content = content
        @expanded_definitions = {}
      end

      def version
        @version ||= Gem::Version.new(content.fetch_path("info", "version"))
      end

      def definitions
        @definitions ||= substitute_regexes(content["definitions"]).tap do |h|
          h.each { |name, v| h[name] = OpenApi::Docs::ObjectDefinition.new.replace(v) }
        end
      end

      def parameters
        @parameters ||= substitute_regexes(content["parameters"])
      end

      def expanded_definition(key)
        @expanded_definitions[key] ||= begin
          definitions[key].tap do |i|
            i["properties"] = substitute_references(i["properties"])
          end
        end
      end

      def example_attributes(key)
        definitions[key]["properties"].each_with_object({}) do |(col, stuff), hash|
          hash[col] = stuff["example"] if stuff.key?("example")
        end
      end

      def base_path
        @base_path ||= @content["basePath"]
      end

      def paths
        @content["paths"]
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

      private

      def substitute_references(object)
        if object.kind_of?(Array)
          object.collect { |i| substitute_references(i) }
        elsif object.kind_of?(Hash)
          return fetch_ref_value(object["$ref"]) if object.keys == ["$ref"]
          object.each { |k, v| object[k] = substitute_references(v) }
        else
          object
        end
      end

      def fetch_ref_value(ref_path)
        _, section, property = ref_path.split("/")
        send(section)[property]
      end

      def substitute_regexes(object)
        if object.kind_of?(Array)
          object.collect { |i| substitute_regexes(i) }
        elsif object.kind_of?(Hash)
          object.each do |k, v|
            object[k] = k == "pattern" ? regexp_from_pattern(v) : substitute_regexes(v)
          end
        else
          object
        end
      end

      def regexp_from_pattern(pattern)
        raise "Pattern #{pattern.inspect} is not a regular expression" unless pattern.starts_with?("/") && pattern.ends_with?("/")
        Regexp.new(pattern[1..-2])
      end
    end
  end
end
