class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :competition
  belongs_to :team

  has_many :photos
  has_many :videos

  attr_accessible :date, :position, :competition_id, :sport_id, :team_id, :user_id, :value, :var, :as_athlete
end
