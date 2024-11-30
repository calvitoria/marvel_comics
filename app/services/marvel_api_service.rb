require "httparty"
require "digest"

class MarvelApiService
  include HTTParty
  BASE_URL = "https://gateway.marvel.com/v1/public"

  def initialize
    @auth_params = generate_auth_params
  end

  def random_story(character_name)
    character = get_character(character_name)
    return "No character found" unless character

    total_stories = character[:total_stories]
    return "No stories found" if total_stories.zero?

    random_offset = rand(0..total_stories)
    get_story(character[:id], random_offset)
  end

  private

  def get_character(name)
    params = @auth_params.merge({name: name})
    response = HTTParty.get("#{BASE_URL}/characters", query: params)

    return nil unless response.success?

    character_details = JSON.parse(response.body)["data"]["results"]&.first
    
    if character_details
      {
        id: character_details['id'],
        name: character_details['name'],
        total_stories: character_details['stories']['available']
      }
    end
  end

  def get_story(character_id, offset)
    params = @auth_params.merge({ limit: 1, offset: offset })

    response = HTTParty.get("#{BASE_URL}/characters/#{character_id}/stories", query: params)
    return nil unless response.success?

    story_details = JSON.parse(response.body)["data"]["results"]&.first
    
    if story_details
      {
        title: story_details['title'],
        description: story_details['description'],
        characters: story_details['characters']['items']
      }
    end
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
