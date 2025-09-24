class ActionDispatch::IntegrationTest
  # Uploads a project with a CSV file and returns the response
  def upload_project_csv(csv_filename, name: 'CSV Test')
    file = fixture_file_upload(csv_filename, 'text/csv')
    post projects_path, params: {
      project: { name: name, csv_file: file }
    }
  end
end
