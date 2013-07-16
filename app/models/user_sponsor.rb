class UserSponsor < ActiveRecord::Base
  belongs_to :user
  belongs_to :sponsor, :class_name => "User"
  
  validates :user_id, :presence => true
  validates :sponsor_id, :presence => true
  
  attr_accessible :sponsor_id, :user_id
end
