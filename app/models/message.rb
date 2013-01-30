class Message < ActiveRecord::Base
  attr_accessible :content, :read, :receiver_id, :user_id
end
