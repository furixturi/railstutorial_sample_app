# generation:
# $ rails generate migration add_remember_digest_to_users remember_digest:string
class AddRememberDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_digest, :string
  end
end
