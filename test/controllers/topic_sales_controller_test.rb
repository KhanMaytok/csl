require 'test_helper'

class TopicSalesControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get ready" do
    get :ready
    assert_response :success
  end

end
