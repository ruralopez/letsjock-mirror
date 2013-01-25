class Sport < ActiveRecord::Base
  has_many :user_sports, :dependent => :destroy
  has_many :users, :through => :user_sports
  has_many :competitions
  has_many :recognitions
  has_many :results
  has_many :teams
  has_many :trains
  belongs_to :parent, :class_name => 'Sport', :foreign_key => 'parent_id'

  attr_accessible :fullpath, :parent_id, :name

  after_save :create_full_path


  private
  def create_full_path
    if self.fullpath.blank?
      if self.parent
        @newpath = self.parent.fullpath + "/" + self.id.to_s
      else
        @newpath = "/" + self.id.to_s
      end
      self.update_attributes(:fullpath => @newpath)
    end
  end


end
