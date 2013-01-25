class Competition < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  has_many :results
  has_many :recognitions

  attr_accessible :end, :event_id, :sport_id, :user_id, :init, :name
end
