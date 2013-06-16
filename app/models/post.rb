class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  has_many :activities

  attr_accessible :content, :event_id, :title, :user_id

  validates :user_id, :presence => true
  validates :content, :presence => true
end
