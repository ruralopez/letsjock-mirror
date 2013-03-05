class Activity < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :photo
  belongs_to :video
  belongs_to :user
  belongs_to :event
  belongs_to :post

  attr_accessible :act_type, :publisher_id, :user_id, :event_id, :photo_id, :video_id, :post_id

end
