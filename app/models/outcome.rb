class Outcome < ActiveRecord::Base
  belongs_to :user
  belongs_to :exam

  attr_accessible :exam_id, :score, :user_id
end
