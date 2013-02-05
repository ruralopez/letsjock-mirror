class Education < ActiveRecord::Base
  belongs_to :user

  attr_accessible :career, :country_id, :degree, :end, :gda, :init, :location, :name, :ncaa, :rank, :state_id, :user_id
end
