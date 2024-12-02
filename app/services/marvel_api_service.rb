require "httparty"
require "digest"

class MarvelApiService
  include HTTParty
  BASE_URL = "https://gateway.marvel.com/v1/public"

  def initialize
    @auth_params = generate_auth_params
  end

  def character(name)
    cache_key = "character_#{name}"

    result = Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      params = @auth_params.merge({ name: name })
      response = HTTParty.get("#{BASE_URL}/characters", query: params)
      results = JSON.parse(response.body)["data"]["results"]

      if results.present?
        Rails.cache.write(cache_key, results&.first)
      end

      results&.first
    end

    result
  end

  def stories(character_id, limit: 1, offset: 0)
    cache_key = "stories_#{character_id}_limit_#{limit}_offset_#{offset}"

    result = Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      params = @auth_params.merge({ limit: limit, offset: offset })
      response = HTTParty.get("#{BASE_URL}/characters/#{character_id}/stories", query: params)
      results = JSON.parse(response.body)["data"]["results"]

      if results.present?
        Rails.cache.write(cache_key, results)
      end

      results
    end

    result
  end

  def character_by_uri(resource_uri)
    cache_key = "character_by_uri_#{Digest::MD5.hexdigest(resource_uri)}"

    result = Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      response = HTTParty.get(resource_uri, query: @auth_params)
      results = JSON.parse(response.body)["data"]["results"]

      if results.present?
        Rails.cache.write(cache_key, results&.first)
      end

      results&.first
    end

    result
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
