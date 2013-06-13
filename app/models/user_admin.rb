class UserAdmin < ActiveRecord::Base
  belongs_to :user
  belongs_to :admin, :class_name => "User"
  
  validates :user_id, :presence => true
  validates :admin_id, :presence => true
  
  attr_accessible :admin_id, :user_id
end
