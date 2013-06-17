class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  belongs_to :competition
  belongs_to :team
  belongs_to :work

  has_many :videos

  attr_accessible :date, :position, :work_id, :competition_id, :sport_id, :team_id, :user_id, :value, :var, :as_athlete, :category, :best_mark

  before_save :check_uniqueness

  def full_mark
    if var != ""
      value.to_s + " " + var
    else
      value.to_s
    end
  end

  def check_uniqueness
    if self.best_mark
      results = Result.where(:user_id => self.user_id, :sport_id => self.sport_id)
      results.each do |result|
        if result.id != self.id
          result.update_attributes(:best_mark => false)
        end
      end
    end
  end

end
