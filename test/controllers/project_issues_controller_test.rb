require "test_helper"

class ProjectIssuesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get project_issues_index_url
    assert_response :success
  end
end
