class UserSport < ActiveRecord::Base
   belongs_to :user
   belongs_to :sport
   
   attr_accessible :sport_id, :user_id, :position
end
