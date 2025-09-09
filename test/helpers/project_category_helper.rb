class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # need to ensure that category selection params get pushed correctly to update the keyword category
  def upload_project(csv_headers = [ "keyword", "search_volume", "brand", "est_traffic",  "url" ],
                    row_one_data = [ "SEO", 100, "jacobpaynecodes", 10, "jacobpaynecodes.com/articles/" ],
                    row_two_data = [ "CRO", 200, "jacobpaynemarketing", 10, "jacobpaynemarketing.com/code/" ])
  # Write a CSV file into tmp/
  get "/projects/new"
  assert_dom "h2", "New Project"
  file_path = Rails.root.join("tmp/test_sample.csv")
  CSV.open(file_path, "w") do |csv|
    csv << csv_headers
    if row_one_data
      csv << row_one_data
    end
    if row_two_data
      csv << row_two_data
    end
  end
  uploaded_file = fixture_file_upload(file_path, "text/csv")
  # confirming modal doesn't popup before post
  assert_not_dom "h2", "Category Suggestions"
  post projects_url, params: { project: { name: "Project3", user_id: users(:one).id, csv_file: uploaded_file } }
  end
end
