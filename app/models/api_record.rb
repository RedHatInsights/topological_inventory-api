require 'rest_client'
require 'json'

class ApiRecord
  def self.api_url
    "http://localhost:3000/api/"
  end

  def self.get_response(url)
    result = RestClient::Request.new(
      :method     => :get,
      :url        => url,
      :user       => "admin",
      :password   => "smartvm",
      :verify_ssl => false
    ).execute
    JSON.parse(result.body)
  end
end