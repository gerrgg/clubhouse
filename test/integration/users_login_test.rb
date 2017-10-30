require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:ron)
  end

  test "login with invalid info" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "log in with valid information" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert is_logged_in?
    ## follow_redirect actually goes to the redirect_to page instead of just checking if we went there
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end


end
