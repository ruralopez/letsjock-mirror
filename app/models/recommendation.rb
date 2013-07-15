class Recommendation < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :content, :user_id, :writer_id, :writer_type, :sport_id, :status # Status { 0: enviado, 1: recibida }
end
