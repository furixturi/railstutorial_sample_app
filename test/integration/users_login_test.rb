require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user, "should redirect to user_path(@user)" # assert redirected to user page
    follow_redirect! # actually visit the redirected page
    assert_template 'users/show', "should render show user template"
    assert_select "a[href=?]", login_path, { :count => 0 }, "log in link should be removed"
    assert_select "a[href=?]", logout_path, {}, "log out link should be added"
    assert_select "a[href=?]", user_path(@user), {}, "user profile link should be added"

    # test log out
    delete logout_path
    assert_not is_logged_in?, "should not be logged in any more"
    assert_redirected_to root_url, "should be redirected to root"
    follow_redirect!
    assert_select "a[href=?]", login_path, {}, "should see log in link"
    assert_select "a[href=?]", logout_path, {count:0}, "should not see log out link"
    assert_select "a[href=?]", user_path(@user), {count:0}, "should not see user profile link" 
  
    # Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0

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

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end

