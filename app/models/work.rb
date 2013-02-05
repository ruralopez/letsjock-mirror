class Work < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport_id

  has_many :trainees

  belongs_to :country

  has_many :photos
  has_many :videos

  attr_accessible :country_id, :end, :init, :company, :user_id, :role, :sport_id, :team_id, :location
end
