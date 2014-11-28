require 'test_helper'

class CoverageSalesControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get ready" do
    get :ready
    assert_response :success
  end

  test "should get confirm" do
    get :confirm
    assert_response :success
  end

end
