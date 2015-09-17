require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "login with valid information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user, "should redirect to user_path(@user)" # assert redirected to user page
    follow_redirect! # actually visit the redirected page
    assert_template 'users/show', "should render show user template"
    assert_select "a[href=?]", login_path, { :count => 0 }, "log in link should be removed"
    assert_select "a[href=?]", logout_path, {}, "log out link should be added"
    assert_select "a[href=?]", user_path(@user), {}, "user profile link should be added"

    # test log out


  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end

