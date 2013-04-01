class Work < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :country

  has_many :teams
  has_many :recognitions
  has_many :results
  has_many :trainees
  has_many :competitions


  has_many :photos
  has_many :videos

  attr_accessible :country_id, :end, :init, :company, :user_id, :role, :sport_id, :location
end
