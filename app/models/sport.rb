class Sport < ActiveRecord::Base
  has_many :user_sports, :dependent => :destroy
  has_many :users, :through => :user_sports

  has_many :competitions
  has_many :recognitions
  has_many :results
  has_many :teams
  has_many :trains
  has_many :trainees
  has_many :works
  belongs_to :parent, :class_name => 'Sport', :foreign_key => 'parent_id'

  has_many :photos
  has_many :videos

  attr_accessible :fullpath, :parent_id, :name

  after_save :create_full_path

  def full_name
    if self.parent_id
      self.name + " - " + Sport.find(self.parent_id).full_name
    else
      self.name
    end
  end
  
  def hasChilds?
    if Sport.find(:all, :conditions => ['parent_id = ?', self.id]).count > 0
      true
    else
      false
    end
  end
  
  def first_parent_name
    ids = self.fullpath.split("/")
    Sport.find(ids[1]).name
  end

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
