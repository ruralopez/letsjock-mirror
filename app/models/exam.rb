class Exam < ActiveRecord::Base
  has_many :outcomes
  has_many :users, :through => :outcomes

  belongs_to :country

  attr_accessible :name, :iso, :country_id
end
