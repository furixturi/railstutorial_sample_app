# $ rails generate integration_test users_index
require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1, per_page: 20).each do |user|
      assert_select 'a[href=?]', user_path(user), {
          text: user.name
        }, "#{user_path(user)}, #{user.name}"
    end
  end
end
