class Work < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport_id

  has_many :photos
  has_many :videos

  attr_accessible :country, :end, :init, :company, :user_id, :role, :sport_id, :team_id
end
