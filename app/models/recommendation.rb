class Recommendation < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content, :user_id, :writer_id
end
