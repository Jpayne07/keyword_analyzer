# frozen_string_literal: true

require 'test_helper'
require 'helpers/session_creation_helper'

class LoginFlowTest < ActionDispatch::IntegrationTest
  setup do
    # signs in with some test information
    sign_in_as(users(:one).email_address, 'password')
  end
  test 'User can log in and redirects to home' do
    # checks that redirect occurs after login
    assert_redirected_to root_path
    follow_redirect!
  end
  test "Can't view the login page if logged in" do
    get new_session_path
    assert_response :redirect
    assert_redirected_to root_path
    # assert_redirected_to root_path
  end
  test "Can't access entries out of user scope" do
    get project_path(users(:one).projects.first.id)
    assert_response :success
    get project_path(users(:two).projects.first.id)
    assert_response :missing
  end
end
