require 'rails_helper'

RSpec.describe "Stories", type: :request do
  let(:mock_service) { instance_double(MarvelApiService) }

  before do
    allow(MarvelApiService).to receive(:new).and_return(mock_service)
  end

  context "when character and stories are found" do
    before do
      character_data = {
        "id" => 1,
        "name" => "Storm",
        "stories" => { "available" => 10 }
      }
      story_data = {
        "title" => "Storm's Greatest Battle",
        "description" => "A huge battle involving Storm.",
        "characters" => { "items" => [ { "name" => "Storm", "resourceURI" => "some_uri" } ] }
      }

      allow(mock_service).to receive(:character).with("storm").and_return(character_data)
      allow(mock_service).to receive(:stories).with(1, limit: 1, offset: anything).and_return(story_data)
      allow(mock_service).to receive(:character_by_uri).and_return({ "name" => "Storm", "thumbnail" => { "path" => "some_path", "extension" => "jpg" } })
    end

    it "returns a successful response and renders the story" do
      get "/stories", params: { character_name: "storm" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('<h2 class="text-5xl mb-4">Storm&#39;s Greatest Battle</h2>')
      expect(response.body).to include('<p class="w-fit">A huge battle involving Storm.</p>')
      expect(response.body).to include('src="some_path/portrait_xlarge.jpg"')
    end
  end

  context "when no character is found" do
    before do
      allow(mock_service).to receive(:character).with("vitoria-calvi").and_return(nil)
    end

    it "returns an error message in the HTML" do
      get "/stories", params: { character_name: "vitoria-calvi" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('No stories found for vitoria-calvi')
    end
  end

  context "when no stories are found for a character" do
    before do
      character_data = {
        "id" => 1,
        "name" => "Storm",
        "stories" => { "available" => 0 }
      }

      allow(mock_service).to receive(:character).with("storm").and_return(character_data)
    end

    it "returns an error message indicating no stories were found" do
      get "/stories", params: { character_name: "storm" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("No stories found")
      expect(response.body).to include("Let's try again, shall we?")
    end
  end
end
