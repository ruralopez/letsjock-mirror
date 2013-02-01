class Work < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport_id

  has_many :photos
  has_many :videos

  attr_accessible :country, :end, :init, :placename, :user_id, :position, :sport_id
end
