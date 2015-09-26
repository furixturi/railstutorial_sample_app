# $ rails generate model Micropost content:text user:references
class Micropost < ActiveRecord::Base
  belongs_to :user
  # order the microposts from newest to oldest
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
