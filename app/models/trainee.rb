class Trainee < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :team

  has_many :photos
  has_many :videos

  attr_accessible :end, :init, :name, :sport_id, :team_id, :trainee_id, :user_id
end
