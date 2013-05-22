class Work < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :country

  has_many :teams, :dependent => :destroy
  has_many :recognitions, :dependent => :destroy
  has_many :results, :dependent => :destroy
  has_many :trainees, :dependent => :destroy
  has_many :competitions, :dependent => :destroy

  has_many :photos, :dependent => :destroy
  has_many :videos, :dependent => :destroy

  attr_accessible :country_id, :end, :init, :company, :user_id, :role, :sport_id, :location
end
