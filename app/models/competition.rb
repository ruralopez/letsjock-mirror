class Competition < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  has_many :results
  has_many :recognitions

  has_many :photos
  has_many :videos

  attr_accessible :end, :event_id, :sport_id, :user_id, :init, :name
end
