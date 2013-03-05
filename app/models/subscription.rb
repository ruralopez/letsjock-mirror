class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :publisher

 attr_accessible :user_id, :publisher_id


end
