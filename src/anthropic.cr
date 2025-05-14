require "db"
require "habitat"
require "json"
require "http/client"

module Anthropic
  Habitat.create do
    setting url : String = "https://api.anthropic.com"
    setting api_key : String
    setting version : String = "2023-06-01"
    setting pool_options : DB::Pool::Options = DB::Pool::Options.new(initial_pool_size: 0, max_idle_pool_size: 25)
  end

  @@pool : DB::Pool(HTTP::Client)? = nil

  def self.pool : DB::Pool(HTTP::Client)
    @@pool ||= DB::Pool.new(Anthropic.settings.pool_options) {
      client = HTTP::Client.new(URI.parse(Turso.settings.url))

      client.before_request do |request|
        request.headers["x-api-key"] = Anthropic.settings.api_key
        request.headers["anthropic-version"] = Anthropic.settings.version
        request.headers["Content-Type"] = "application/json"
      end

      client
    }
  end
end

require "./anthropic/*"
