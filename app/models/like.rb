class Like < ActiveRecord::Base
  attr_accessible :object_id, :object_type, :user_id
  
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :object_id, :presence => true
  validates :object_type, :presence => true
end
