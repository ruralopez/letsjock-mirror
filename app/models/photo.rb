class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :competition
  belongs_to :recognition
  belongs_to :result
  belongs_to :team
  belongs_to :train

  attr_accessible :comment, :title, :url, :user_id, :competition_id, :recognition_id, :result_id, :team_id, :train_id, :sport_id
end
