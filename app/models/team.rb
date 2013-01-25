class Team < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  has_many :trains
  has_many :results
  has_many :recognitions

  attr_accessible :end, :sport_id, :user_id, :init, :name
end
