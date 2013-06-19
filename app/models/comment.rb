class Comment < ActiveRecord::Base
  attr_accessible :comment, :object_id, :object_type, :user_id
  
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :object_id, :presence => true
  validates :object_type, :presence => true
  validates :comment, :presence => true
end
