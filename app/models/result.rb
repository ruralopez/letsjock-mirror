class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :competition
  belongs_to :team


  attr_accessible :date, :description, :competition_id, :sport_id, :team_id, :user_id, :value, :var
end
