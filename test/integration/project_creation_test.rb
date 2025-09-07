require "test_helper"
require_relative "session_creation_helper"
require "csv"

$stdout.sync = true
class ProjectCreationTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one).email_address, "password")
  end
  # need to test import keywords first
  # there are 2 pieces here - the project creation, which only accepts the name and user id
  # then the keywords piece, which will actually hold all of the keyword data.
  #
  # testing the project creation first, regardless of data
  #
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
  # Write a CSV file into tmp/
  get "/projects/new"
  assert_dom "h2", "New Project"
  file_path = Rails.root.join("tmp/test_sample.csv")
  CSV.open(file_path, "w") do |csv|
    csv << [ "keyword", "search_volume", "brand" ]
  end
  uploaded_file = fixture_file_upload(file_path, "text/csv")
  # confirming modal doesn't popup before post
  assert_not_dom "h2", "Category Suggestions"
  post projects_url, params: { project: { name: "Project3", user_id: users(:one).id, csv_file: uploaded_file } }
  assert_dom "h2", "Category Suggestions"
end
test "upon form submission, bad headers/data include error" do
  # bad data makes it in still, import needs to throw an error
  file_path = Rails.root.join("tmp/test_sample.csv")
  CSV.open(file_path, "w") do |csv|
    csv << [ "bad_data" ]
  end
  uploaded_file = fixture_file_upload(file_path, "text/csv")
  # confirming modal doesn't popup before post
  assert_not_dom "h2", "Category Suggestions"
  post projects_url, params: { project: { name: "Project3", user_id: users(:one).id, csv_file: uploaded_file } }
  assert_dom "h2", "Category Suggestions"
end
end
