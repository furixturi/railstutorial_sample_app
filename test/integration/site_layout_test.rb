require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get signup_path
    assert_response :success
    assert_select "title", full_title("Sign up")

    log_in_as(@user)

    get root_path
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a", text: 'Account'
    assert_select "a[href=?]", user_path(@user), text: 'Profile'
    assert_select "a[href=?]", edit_user_path(@user), text: 'Settings'
    assert_select "a[href=?]", logout_path, text: 'Log out'

  end
end
