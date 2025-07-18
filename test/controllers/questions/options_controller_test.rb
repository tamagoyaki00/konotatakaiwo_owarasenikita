require "test_helper"

class Questions::OptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get questions_options_new_url
    assert_response :success
  end

  test "should get create" do
    get questions_options_create_url
    assert_response :success
  end

  test "should get edit" do
    get questions_options_edit_url
    assert_response :success
  end

  test "should get update" do
    get questions_options_update_url
    assert_response :success
  end

  test "should get destroy" do
    get questions_options_destroy_url
    assert_response :success
  end
end
