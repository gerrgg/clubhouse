require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "The Clubhouse"
  end

  test "should get root" do
    get root_path
    assert_response :success
    assert_select "title", {:count => 1, :text => "Home | #{@base_title}"}
  end

  test "should get contact page" do
    get contact_path
    assert_response :success
    assert_select "title", {:count => 1, :text => "Contact | #{@base_title}"}
  end

  test "should get about page" do
    get about_path
    assert_response :success
    assert_select "title", {:count => 1, :text => "About | #{@base_title}"}
  end
end
