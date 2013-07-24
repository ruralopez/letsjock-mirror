class Agent < ActiveRecord::Base
  belongs_to :users
  
  validates :user_id, :presence => true
  validates :name, :presence => true
  validates :lastname, :presence => true
  
  attr_accessible :user_id, :name, :lastname, :email, :phone
end
