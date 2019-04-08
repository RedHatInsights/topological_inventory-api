module Api
  Docs = ::OpenApi::Docs.new(Dir.glob(Rails.root.join("public", "doc", "openapi*.json")))
end
