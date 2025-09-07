require "test_helper"

class UserCreationTest < ActionDispatch::IntegrationTest
  test "user can visit page and create" do
    get "/users/new"
    assert_dom "h2", "New User"
    post users_path, params: { user: {  email_address: "test@test.com", password: "password"  }  }
    assert_redirected_to root_path
  end
end
