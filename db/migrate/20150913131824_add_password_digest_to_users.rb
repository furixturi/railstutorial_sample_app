# generated with the command
# $ rails generate migration add_password_digest_to_users password_digest:string

class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
  end
end
