class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :competition
  belongs_to :team
  belongs_to :work

  has_many :photos
  has_many :videos

  attr_accessible :date, :position, :work_id, :competition_id, :sport_id, :team_id, :user_id, :value, :var, :as_athlete, :category

  def full_mark
    if var != ""
      value.to_s + " " + var
    else
      value.to_s
    end
  end
end
