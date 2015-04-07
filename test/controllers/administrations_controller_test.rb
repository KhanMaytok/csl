require 'test_helper'

class AdministrationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get stadistics" do
    get :stadistics
    assert_response :success
  end

end
