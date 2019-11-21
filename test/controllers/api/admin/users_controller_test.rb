require 'test_helper'

class Api::Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_admin_users_index_url
    assert_response :success
  end

  test "should get create" do
    get api_admin_users_create_url
    assert_response :success
  end

  test "should get edit" do
    get api_admin_users_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get api_admin_users_destroy_url
    assert_response :success
  end

  test "should get update" do
    get api_admin_users_update_url
    assert_response :success
  end

end
