class Country < ActiveRecord::Base
  has_many :exams

  has_many :works

  attr_accessible :iso, :name, :id
end
