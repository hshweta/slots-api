require 'test_helper'

class SlotsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get slots_url
    assert_response :success
  end
end
