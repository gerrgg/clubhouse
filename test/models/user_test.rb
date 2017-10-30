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

  test "email validation should accept valid addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        assert @user.valid?, "#{valid_address.inspect} should be valid"
      end
    end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "emails should be unqiue" do
    user2 = @user.dup
    user2.email = @user.email.upcase
    @user.save
    assert_not user2.valid?
  end

  test "emails should be saved downcase" do
    @user.email.upcase!
    @user.save
    assert_equal @user.email.downcase, @user.email
  end

  test "names are titleized before creation" do
    @user.name.downcase!
    @user.save
    assert_equal @user.name.titleize, @user.reload.name
  end

end
