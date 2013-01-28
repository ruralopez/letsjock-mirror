class Recognition < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :competition
  belongs_to :team

  has_many :photos
  has_many :videos

  attr_accessible :date, :description, :competition_id, :sport_id, :team_id, :user_id
end
