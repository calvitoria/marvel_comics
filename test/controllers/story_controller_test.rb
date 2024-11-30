require "test_helper"

class StoryControllerTest < ActionDispatch::IntegrationTest
  setup do
    ENV["PUBLIC_KEY"] = "mock_public_key"
    ENV["PRIVATE_KEY"] = "mock_private_key"
  end

  test "should get index" do
    get story_index_url
    assert_response :success

    assert_includes @response.body, "id"
  end
end
