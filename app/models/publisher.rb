class Publisher < ActiveRecord::Base
   belongs_to :user
   belongs_to :event

   has_many :subscriptions
   has_many :activities

   attr_accessible :pub_type, :user_id, :event_id

end
