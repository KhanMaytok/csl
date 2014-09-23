require 'test_helper'

class PatientsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get recent" do
    get :recent
    assert_response :success
  end

end
