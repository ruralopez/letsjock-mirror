class Notification < ActiveRecord::Base

  belongs_to :user
  belongs_to :event

  attr_accessible :user_id, :user2_id, :event_id, :read, :not_type

end