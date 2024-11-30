require "httparty"
require "digest"

class MarvelApiService
  include HTTParty
  BASE_URL = "https://gateway.marvel.com/v1/public"

  def initialize
    @auth_params = generate_auth_params
  end

  def character(name)
    params = @auth_params.merge({ name: name })
    response = HTTParty.get("#{BASE_URL}/characters", query: params)

    return nil unless response.success?

    JSON.parse(response.body)["data"]["results"]&.first
  end

  def stories(character_id, limit: 1, offset: 0)
    params = @auth_params.merge({ limit: limit, offset: offset })
    response = HTTParty.get("#{BASE_URL}/characters/#{character_id}/stories", query: params)

    return nil unless response.success?

    JSON.parse(response.body)["data"]["results"]
  end

  def character_by_uri(resource_uri)
    response = HTTParty.get(resource_uri, query: @auth_params)
    return nil unless response.success?

    JSON.parse(response.body)["data"]["results"]&.first
  end

  private

  def generate_auth_params
    ts = Time.now.to_i.to_s
    public_key = ENV["PUBLIC_KEY"]
    private_key = ENV["PRIVATE_KEY"]
    hash = Digest::MD5.hexdigest(ts + private_key + public_key)

    { ts: ts, apikey: public_key, hash: hash }
  end
end
