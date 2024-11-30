require "httparty"
require "digest"

class MarvelApiService
  include HTTParty
  BASE_URL_CHARACTERS = "https://gateway.marvel.com/v1/public/characters"

  def initialize
    @auth_params = generate_auth_params
  end

  def character_details(character_name)
    characters({name: character_name})
  end

  def story_characters(story_id)
    characters({stories: story_id})
  end

  def character_stories(character_id, offset = nil)
    stories_url = "#{BASE_URL_CHARACTERS}/#{character_id}/stories"
    params = @auth_params.merge({ limit: 1 })
    params[:offset] = offset if offset

    response = HTTParty.get(stories_url, query: params)
    body = response.body

    byebug

    JSON.parse(body)["data"]
  end

  def total_stories(character_id, offset: 0)
    stories(character_id, offset: offset)
  end

  def story_by_id(character_id, offset: 0)
    stories(character_id, offset: offset)
  end

  private

  def characters(query_param)
    params = @auth_params.merge(query_param)
    response = HTTParty.get(BASE_URL_CHARACTERS, query: params)
    body = response.body

    JSON.parse(body)["data"]["results"]
  end

  def stories(character_id, offset:)
    stories_url = "#{BASE_URL_CHARACTERS}/#{character_id}/stories"
    params = @auth_params.merge({ limit: 1, offset: offset })

    response = HTTParty.get(stories_url, query: params)
    body = response.body

    JSON.parse(body)["data"]
  end

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
