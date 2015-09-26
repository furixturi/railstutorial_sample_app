# $ rails generate model Micropost content:text user:references
class Micropost < ActiveRecord::Base
  belongs_to :user
end
