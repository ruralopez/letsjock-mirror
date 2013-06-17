class Team < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport
  belongs_to :work

  has_many :trainees, :dependent => :nullify 
  has_many :trains, :dependent => :nullify
  has_many :results, :dependent => :nullify
  has_many :recognitions, :dependent => :nullify
  has_many :competitions, :dependent => :nullify

  has_many :videos

  attr_accessible :end, :sport_id, :user_id, :init, :name, :category, :as_athlete, :work_id, :localization

  def name_category
    if category
      name + " - " + category
    else
      name
    end
  end
end
