require "test_helper"
require "helpers/session_creation_helper"
require "helpers/project_category_helper"
require "csv"

$stdout.sync = true
class ProjectCreationTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one).email_address, "password")
  end
  # then the keywords piece, which will actually hold all of the keyword data.
  # testing the project creation first, regardless of data
  test "can see form and add project" do
    assert_generates "/", { controller: "pages", action: "home" }
    get "/projects/new"
    assert_dom "h2", "New Project"
    get "/projects"
    post projects_url, params: { project: { name: "Project3", user_id: users(:one).id } }
    assert_not Project.find_by(name: "Project3").nil?
  end
  # testing modal popup
  test "upon form submission, modal popup" do
  csv_headers = [ "keyword", "search_volume", "brand", "est_traffic",  "url" ]
  upload_project(csv_headers)
  assert_dom "h2", "Category Suggestions"
  end
  test "upon form submission, bad headers/data include error" do
    csv_headers = [ "bad data" ]
    upload_project(csv_headers)
    assert_response 422
  end
  test "upon form submission, test category option selection" do
    upload_project
    puts @response.body
    assert_select "input[type=checkbox][data-name=?]", "articles"
  end
  test "upon form submission, test brand selection" do
    upload_project
    puts @response.body
    assert_select "option[value=jacobpaynemarketing]"
  end
end
