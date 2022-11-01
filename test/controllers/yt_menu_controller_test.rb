require "test_helper"

class YtMenuControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get yt_menu_index_url
    assert_response :success
  end
end
