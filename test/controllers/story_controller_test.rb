require "test_helper"
require "webmock/minitest"

class StoryControllerTest < ActionDispatch::IntegrationTest
  setup do
    ENV["PUBLIC_KEY"] = "mock_public_key"
    ENV["PRIVATE_KEY"] = "mock_private_key"
    stub_request(:get, "https://api.marvel.com/v1/stories").
      to_return(status: 200, body: story_data.to_json)
  end

  test "should get index" do
    get stories_url
    assert_response :success
    # You can also check if the stubbed request was actually called
    assert_requested :get, "https://api.marvel.com/v1/stories", times: 1
  end
end
