require "httparty"
require "digest"

class MarvelApiService
  include HTTParty

  def initialize
    @auth_params = generate_auth_params
  end

  def character_details(name)
    url = "https://gateway.marvel.com/v1/public/characters?name=#{name}&#{@auth_params}"
    response = HTTParty.get(url)
    body = response.body
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
