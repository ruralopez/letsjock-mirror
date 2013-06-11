class Stat < ActiveRecord::Base
  belongs_to :user

  attr_accessible :info, :type, :user_id

  #before_save :set_data
  serialize :info, Hash

  def after_initialize
    self.info ||= {}
  end

  #def set_info
  #  if self.info[:tags].is_a? String
  #    self.info[:tags] = self.info[:tags].split(", ")
  #  end
  #end

end
