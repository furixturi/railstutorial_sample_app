# ¢ rails generate model Relationship follower_id:integer followed_id:integer

class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps null: false
    end
  end
end
