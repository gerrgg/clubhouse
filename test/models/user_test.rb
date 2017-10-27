require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Jhon Doe', email: 'greg@gmail.com',
                    password: 'foobar', password_confirmation: 'foobar')
  end

  test "test 'test setup'" do
    assert @user.name = "Jhon Doe"
  end

  test "users name cannot be blank" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "users email cannot be blank" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "password_confirmation and password must match" do
    @user.password = "foobar"
    @user.password_confirmation = 'invalid'
    assert_not @user.valid?
  end

  test 'password must be atleast 6 chars' do
    @user.password, @user.password_confirmation = 'foo'
    assert_not @user.valid?
  end

  test "invalid email" do
    @user.email = '123.com'
    assert_not @user.valid?
    @user.email = '@.com'
    assert_not @user.valid?
  end

  test "valid email" do
    assert @user.valid?
  end


end
