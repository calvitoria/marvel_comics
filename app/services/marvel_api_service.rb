require "httparty"
require "digest"

class MarvelApiService
  include HTTParty
  BASE_URL_CHARACTERS = "https://gateway.marvel.com/v1/public/characters"
  
  def initialize
    @auth_params = generate_auth_params
  end

  def character_details(name)
    params = @auth_params.merge({ name: name })
    response = HTTParty.get(BASE_URL_CHARACTERS, query: params)
    body = response.body

    JSON.parse(body)["data"]["results"]
  end

  def character_stories(character_id, offset = nil)
    stories_url = "#{BASE_URL_CHARACTERS}/#{character_id}/stories"
    params = @auth_params.merge({ limit: 1 })
    params[:offset] = offset if offset
  
    response = HTTParty.get(stories_url, query: params)
    body = response.body

    JSON.parse(body)["data"]
  end

  private

  def generate_auth_params
    ts = Time.now.to_i.to_s
    public_key = ENV["PUBLIC_KEY"]
    private_key = ENV["PRIVATE_KEY"]
    hash = generate_hash(ts, private_key, public_key)

    { ts: ts, apikey: public_key, hash: hash }
  end

  def generate_hash(ts, private_key, public_key)
    Digest::MD5.hexdigest(ts + private_key + public_key)
  end
end
