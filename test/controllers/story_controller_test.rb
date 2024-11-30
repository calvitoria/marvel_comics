require "test_helper"

class StoryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get story_index_url
    assert_response :success

    assert_includes @response.body, "id"
  end
end
