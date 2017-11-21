require 'test_helper'

class AccountActivationTest < ActionDispatch::IntegrationTest


  test "token is created and is digested into db" do
    post users_path, params: { user: { name: 'testman smith',
                                       email: 'testman@test.com',
                                       password: 'password',
                                       password_confirmation: 'password'} }
    follow_redirect!
    assert_template root_path
    assert flash[:warning] = "Account not activated, please check email."
    assert_not is_logged_in?
    
  end
end
