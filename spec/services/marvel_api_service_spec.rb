require 'rails_helper'
require 'webmock/rspec'
require 'json'

RSpec.describe MarvelApiService, type: :service do
  let(:service) { MarvelApiService.new }
  let(:character_name) { "Iron Man" }
  let(:character_id) { 1011334 }
  let(:public_key) { ENV['PUBLIC_KEY'] }
  let(:private_key) { ENV['PRIVATE_KEY'] }

  before do
    stub_request(:get, "https://gateway.marvel.com/v1/public/characters")
      .with(query: hash_including(apikey: public_key))
      .to_return(status: 200, body: '{"data":{"results":[{"id":1011334,"name":"Iron Man"}]}}', headers: {})

    stub_request(:get, "https://gateway.marvel.com/v1/public/characters/#{character_id}/stories")
      .with(query: hash_including(apikey: public_key))
      .to_return(status: 200, body: '{"data":{"results":[{"id":1,"title":"Iron Man Story"}]}}', headers: {})

    stub_request(:get, "https://gateway.marvel.com/v1/public/characters/#{character_id}")
      .with(query: hash_including(apikey: public_key))
      .to_return(status: 200, body: '{"data":{"results":[{"id":1011334,"name":"Iron Man"}]}}', headers: {})
  end

  describe "#character" do
    it "returns character data for a valid character name" do
      character = service.character(character_name)
      expect(character).to be_present
      expect(character["name"]).to eq("Iron Man")
    end

    it "returns nil when no character is found" do
      stub_request(:get, "https://gateway.marvel.com/v1/public/characters")
        .with(query: hash_including(apikey: public_key))
        .to_return(status: 200, body: '{"data":{"results":[]}}', headers: {})

      character = service.character("NonExistentCharacter")
      expect(character).to be_nil
    end
  end

  describe "#stories" do
    it "returns story data for a valid character ID" do
      story = service.stories(character_id)
      expect(story).to be_present
      expect(story["title"]).to eq("Iron Man Story")
    end

    it "returns nil when no story is found" do
      stub_request(:get, "https://gateway.marvel.com/v1/public/characters/#{character_id}/stories")
        .with(query: hash_including(apikey: public_key))
        .to_return(status: 200, body: '{"data":{"results":[]}}', headers: {})

      story = service.stories(character_id)
      expect(story).to be_nil
    end
  end

  describe "#character_by_uri" do
    let(:resource_uri) { "https://gateway.marvel.com/v1/public/characters/#{character_id}" }

    it "returns character data for a valid URI" do
      character = service.character_by_uri(resource_uri)
      expect(character).to be_present
      expect(character["name"]).to eq("Iron Man")
    end

    it "returns nil when no data is found for URI" do
      stub_request(:get, resource_uri)
        .with(query: hash_including(apikey: public_key))
        .to_return(status: 200, body: '{"data":{"results":[]}}', headers: {})

      character = service.character_by_uri(resource_uri)
      expect(character).to be_nil
    end
  end
end
