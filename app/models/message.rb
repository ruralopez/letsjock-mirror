class Message < ActiveRecord::Base
  belongs_to :user

  attr_accessible :content, :read, :receiver_id, :user_id
end
