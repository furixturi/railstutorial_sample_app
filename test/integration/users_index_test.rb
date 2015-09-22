# $ rails generate integration_test users_index
require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1, per_page: 20).each do |user|
      assert_select 'a[href=?]', user_path(user), {
          text: user.name
        }, "cannot find #{user_path(user)}, #{user.name}"
    end
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    
    first_page_of_users = User.paginate(page:1, per_page: 20)    
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end      
    end

    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
end
