class SponsorsEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  attr_accessible :user_id, :event_id, :category
end
