# spec/controllers/stories_controller_spec.rb
require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  let(:mock_service) { double('MarvelApiService') }
  let(:mock_auth_params) { { ts: '1', apikey: 'mock_public_key', hash: 'mock_hash' } }

  let(:character_data) {
    {
      "id" => 1,
      "name" => 'Storm',
      "image" => 'https://example.com/storm_image.jpg',
      "stories" => {
        "available" => 5
      }
    }
  }

  let(:story_data) {
    [ {
      "title" => 'Fake Story',
      "description" => 'This is a fake story',
      "characters" => {
        "items" => [
          { "resourceURI" => "https://example.com/api/character/1", "name" => "Storm" }
        ]
      }
    } ]
  }

  before do
    allow(MarvelApiService).to receive(:new).and_return(mock_service)
    allow_any_instance_of(MarvelApiService).to receive(:generate_auth_params).and_return(mock_auth_params)
    allow(mock_service).to receive(:character).with("storm").and_return(character_data)
    allow(mock_service).to receive(:stories).with(character_data["id"], limit: 1, offset: anything).and_return(story_data)
    allow(mock_service).to receive(:character_by_uri).with("https://example.com/api/character/1").and_return({
      "name" => "Storm",
      "thumbnail" => { "path" => "https://example.com/storm_image", "extension" => "jpg" }
    })

    allow(controller).to receive(:render)
  end

  describe 'GET #index' do
    it 'returns a successful response and assigns stories' do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:story)).to eq({
        title: 'Fake Story',
        description: 'This is a fake story',
        characters: [
          {
            name: 'Storm',
            image: 'https://example.com/storm_image/portrait_xlarge.jpg'
          }
        ]
      })
    end

    context 'when character data is not found' do
      before do
        allow(mock_service).to receive(:character).with("storm").and_return(nil)
      end

      it 'returns an error message and assigns the error' do
        get :index
        expect(assigns(:error)).to eq("No character found with name storm")
      end
    end

    context 'when character data is not found' do
      before do
        allow(mock_service).to receive(:character).with("storm").and_return(nil)
      end

      it 'returns an error message and assigns the error' do
        get :index
        expect(assigns(:error)).to eq("No character found with name storm")
      end
    end
  end
end
