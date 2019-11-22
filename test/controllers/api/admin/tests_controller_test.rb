require 'test_helper'

class Api::Admin::TestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_admin_tests_index_url
    assert_response :success
  end

  test "should get edit" do
    get api_admin_tests_edit_url
    assert_response :success
  end

  test "should get update" do
    get api_admin_tests_update_url
    assert_response :success
  end

  test "should get create" do
    get api_admin_tests_create_url
    assert_response :success
  end

  test "should get destroy" do
    get api_admin_tests_destroy_url
    assert_response :success
  end

end
