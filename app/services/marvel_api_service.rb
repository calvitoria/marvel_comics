class MarvelApiService
  include HTTParty
  BASE_URL = "https://gateway.marvel.com/v1/public"

  def initialize
    @auth_params = generate_auth_params
    @cache_service = CacheService.new
  end

  def character(name)
    cache_key = "character_#{name}"
    @cache_service.fetch(cache_key) do
      results = make_api_call("#{BASE_URL}/characters", name: name)
      @cache_service.write(cache_key, results&.first) if results.present?
      results&.first
    end
  end

  def stories(character_id, limit: 1, offset: 0)
    cache_key = "stories_#{character_id}_limit_#{limit}_offset_#{offset}"
    @cache_service.fetch(cache_key) do
      results = make_api_call("#{BASE_URL}/characters/#{character_id}/stories", limit: limit, offset: offset)
      @cache_service.write(cache_key, results&.first) if results.present?
      results&.first
    end
  end

  def character_by_uri(resource_uri)
    cache_key = "character_by_uri_#{Digest::MD5.hexdigest(resource_uri)}"
    @cache_service.fetch(cache_key) do
      response = HTTParty.get(resource_uri, query: @auth_params)
      results = JSON.parse(response.body)["data"]["results"]
      @cache_service.write(cache_key, results&.first) if results.present?
      results&.first
    end
  end

  private

  def make_api_call(endpoint, params)
    params = @auth_params.merge(params)
    response = HTTParty.get(endpoint, query: params)
    JSON.parse(response.body)["data"]["results"]
  end

  def generate_auth_params
    ts = Time.now.to_i.to_s
    public_key = ENV["PUBLIC_KEY"]
    private_key = ENV["PRIVATE_KEY"]
    hash = Digest::MD5.hexdigest(ts + private_key + public_key)

    { ts: ts, apikey: public_key, hash: hash }
  end
end
