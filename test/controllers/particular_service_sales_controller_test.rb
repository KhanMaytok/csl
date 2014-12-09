require 'test_helper'

class ParticularServiceSalesControllerTest < ActionController::TestCase
  test "should get _form_service_sales" do
    get :_form_service_sales
    assert_response :success
  end

  test "should get _select_name_change" do
    get :_select_name_change
    assert_response :success
  end

  test "should get _table_service_sales" do
    get :_table_service_sales
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get ready_sales" do
    get :ready_sales
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
