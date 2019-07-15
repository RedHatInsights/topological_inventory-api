scheme = ENV["SOURCES_SCHEME"] || 'http'
host = ENV["SOURCES_HOST"] || 'localhost'
port = ENV["SOURCES_PORT"] || 3000

SourcesApiClient.configure do |config|
  config.scheme = scheme
  config.host   = "#{host}:#{port}"
end
