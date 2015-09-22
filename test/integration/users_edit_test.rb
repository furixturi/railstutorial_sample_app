# generation command:
# $ rails generate integration_test users_edit
require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = users(:michael)
  end

  test "unsuccessful edit" do
  	log_in_as(@user) # defined in test_helper.rb
  	get edit_user_path(@user)
  	assert_template 'users/edit'
  	patch user_path(@user), user: {
  		name: "",
  		email: "foo@invalid",
  		password: "foo",
  		password_confirmation: "bar"
  	}
  	assert_template 'users/edit'
  end

  test "successful edit" do
  	log_in_as(@user)
  	get edit_user_path(@user)
  	assert_template 'users/edit'
  	name = "Foo Bar"
  	email = "foo@bar.com"
  	patch user_path(@user), user: {
  		name: name,
  		email: email,
  		password: "",
  		password_confirmation: ""
  	}
  	assert_not flash.empty?
  	assert_redirected_to @user

  	@user.reload # reload user attributes from current db
  	assert_equal name, @user.name
  	assert_equal email, @user.email
  end

  # test friendly redirect for user who tries to edit without logging in
  test "successful edit with friendly forwarding" do
  	get edit_user_path(@user)
  	log_in_as(@user)
  	assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url], "session[:forwarding_url] should be nil"
  	name = "Foo Bar"
  	email = "foo@bar.com"
  	patch user_path(@user), user: {
  		name: name,
  		email: email,
  		password: "",
  		password_confirmation: ""
  	}
  	assert_not flash.empty?
  	assert_redirected_to @user
  	@user.reload
  	assert_equal name, @user.name
  	assert_equal email, @user.email
  end
  
end
