class Train < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :team

  has_many :videos

  attr_accessible :end, :sport_id, :team_id, :trainer_id, :user_id, :init, :name
end
