class Recognition < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :competition
  belongs_to :team
  belongs_to :work

  has_many :videos

  attr_accessible :date, :description, :work_id, :competition_id, :sport_id, :team_id, :user_id, :awarded_by, :as_athlete
end
