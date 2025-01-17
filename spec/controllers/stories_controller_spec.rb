require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  let(:mock_service) { double('MarvelApiService') }

  let(:character_data) do
    {
      "id" => 1,
      "name" => 'Storm',
      "image" => 'https://example.com/storm_image.jpg',
      "stories" => {
        "available" => 5
      },
      "description" => "The weather goddess with the power of storms!",
      "thumbnail" => { "path" => "https://example.com/storm_image", "extension" => "jpg" }
    }
  end

  let(:story_data) do
    {
      "title" => 'Fake Story',
      "description" => 'This is a fake story',
      "characters" => {
        "items" => [
          { "resourceURI" => "https://example.com/api/character/1", "name" => "Storm" }
        ]
      }
    }
  end

  before do
    allow(MarvelApiService).to receive(:new).and_return(mock_service)

    allow(mock_service).to receive(:character).with("storm").and_return(character_data)
    allow(mock_service).to receive(:character).with("Storm").and_return(character_data)

    allow(mock_service).to receive(:stories).with(character_data["id"], limit: 1, offset: anything).and_return(story_data)
    allow(mock_service).to receive(:character_by_uri).with("https://example.com/api/character/1").and_return(character_data)

    allow(controller).to receive(:render)
  end

  describe 'GET #index' do
    context 'when the character data and story are found' do
      it 'returns a successful response and assigns the story and favorite_character' do
        get :index, params: { character_name: "Storm" }

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

        expect(assigns(:favorite_character)).to eq(character_data)
      end
    end

    context 'when no stories are available for the character' do
      before do
        character_data["stories"]["available"] = 0
        allow(mock_service).to receive(:stories).and_return([])
      end

      it 'returns an error message and assigns the error' do
        get :index, params: { character_name: "Storm" }

        expect(response).to have_http_status(:success)
        expect(assigns(:error)).to eq("No stories found")
      end
    end

    context 'when no character is found' do
      before do
        allow(mock_service).to receive(:character).and_return(nil)
      end

      it 'returns an error message when no character data is found' do
        get :index, params: { character_name: "UnknownCharacter" }

        expect(response).to have_http_status(:success)
        expect(assigns(:error)).to eq("No stories found for UnknownCharacter")
      end
    end
  end
end
