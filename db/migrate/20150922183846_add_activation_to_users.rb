# $ rails generate migration add_activation_to_users activation_digest:string activated:boolean activated_at:timedate
class AddActivationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_digest, :string
    add_column :users, :activated, :boolean
    add_column :users, :activated_at, :datetime
  end
end
