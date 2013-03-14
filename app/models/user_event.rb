class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  set_primary_key :event_id

  attr_accessible :event_id, :user_id
end
