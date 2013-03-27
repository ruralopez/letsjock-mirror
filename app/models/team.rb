class Team < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport

  has_many :trains
  has_many :results
  has_many :recognitions
  has_many :competitions

  has_many :photos
  has_many :videos

  attr_accessible :end, :sport_id, :user_id, :init, :name, :category, :as_athlete

  def name_category
    if category
      name + " - " + category
    else
      name
    end
  end
end
