require "test_helper"

class NgramControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ngram_index_url
    assert_response :success
  end

  test "should get show" do
    get ngram_show_url
    assert_response :success
  end

  test "should get create" do
    get ngram_create_url
    assert_response :success
  end

  test "should get search" do
    get ngram_search_url
    assert_response :success
  end
end
