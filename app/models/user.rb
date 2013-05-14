class User < ActiveRecord::Base
  has_many :user_sports, :dependent => :destroy
  has_many :sports, :through => :user_sports

  has_one :publishers
  has_many :subscriptions
  has_many :activities
  has_many :notifications

  has_many :educations, :dependent => :destroy
  has_many :outcomes
  has_many :exams, :through => :outcomes

  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :followed_users, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship", :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  has_many :competitions, :dependent => :destroy
  has_many :recognitions, :dependent => :destroy
  has_many :results, :dependent => :destroy
  has_many :teams, :dependent => :destroy
  has_many :trains, :dependent => :destroy
  has_many :trainees, :dependent => :destroy
  has_many :works, :dependent => :destroy

  has_many :photos, :dependent => :destroy
  has_many :videos, :dependent => :destroy

  has_many :user_events, :dependent => :destroy
  has_many :events, :through => :user_events
  has_many :event_admins, :dependent => :destroy
  has_many :events, :through => :event_admins
  has_many :posts

  has_many :messages

  attr_accessible :email, :lastname, :name, :password, :password_confirmation, :gender, :birth, :citybirth, :country, :phone, :resume, :height, :weight, :profilephotourl, :authentic_email, :isSponsor, :preferences

  before_save :profilepic
  before_save { |user| user.email = email.downcase}
  before_save :set_preferences
  before_create :create_remember_token
  before_create :create_email_token

  has_secure_password
  serialize :preferences, Hash

  validates :name, :presence => true
  validates :lastname, :presence => true
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => { :with => VALID_EMAIL}, :uniqueness => { :case_sensitive => false}
  validates :password, :presence => true, :confirmation => true, :length => { :minimum => 6 }, :on => :create
  validates :password, :confirmation => true, :length => { :minimum => 6 }, :on => :update, :unless => lambda{ |user| user.password.blank? }

  def after_initialize
    self.preferences ||= {} 
  end

  def full_name
    if self.isSponsor
      name
    else
      name + " " + lastname  
    end
  end

  def age
    now = Time.now.utc.to_date
    now.year - self.birth.year - (self.birth.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def sport_show
    if UserSport.exists?(:user_id => self.id)
      Sport.find(UserSport.all(:conditions => ["user_id = ?", self.id]).last.sport_id).full_name
    else
      "No sport yet!"
    end
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(:followed_id => other_user.id)
    Subscription.new(:user_id => self.id, :publisher_id => Publisher.find_by_user_id(other_user.id).id).save
    Activity.new(:publisher_id => Publisher.find_by_user_id(self.id).id, :user_id => other_user.id, :act_type => "010").save
    Activity.new(:publisher_id => Publisher.find_by_user_id(other_user.id).id, :act_type => "011").save
    Notification.new(:user_id => other_user.id, :user2_id => self.id, :read => false, :not_type => "003").save
  end

  def unfollow!(other_user)
    relationships.first(:conditions => ["followed_id = ?", other_user.id]).destroy
    Subscription.first(:conditions => ["user_id = ? AND publisher_id = ?", self.id, Publisher.find_by_user_id(other_user.id).id]).destroy
  end

  def profilepic
    self.profilephotourl ||= "default-profile.png"
  end
  
  def set_preferences
    if self.preferences[:industries].is_a? String
      self.preferences[:industries] = self.preferences[:industries].split(", ")
    end
  end

  def last_message_with(user)
    Message.last(:conditions => ["(user_id = ? AND receiver_id = ?) OR (user_id = ? AND receiver_id = ?)", user.id, self.id, self.id, user.id])
  end

  def messages_with(user)
    Message.all(:conditions => ["(user_id = ? AND receiver_id = ?) OR (user_id = ? AND receiver_id = ?)", user.id, self.id, self.id, user.id])
  end

  def unread_messages
    @aux = Message.all(:conditions => ["receiver_id = ?", self.id])
    @unread = []
    @aux.each do |um|
      unless um.read
        @unread << um
      end
    end
    @unread
  end

  def new_notifications
    @aux = Notification.all(:conditions => ["user_id = ?", self.id])
    @new = []
    @aux.each do |nn|
      unless nn.read
        @new << nn
      end
    end
    @new
  end
  
  def isAdmin? #Obviamente hay que crear el atributo, pero por mientras
    self.id == 1 # Si es el usuario LetsJock
  end

  private
  def create_remember_token
    #self.remember_token = SecureRandom.urlsafe_base64
    self.remember_token = SecureRandom.base64.tr("+/", "-_")
  end

  def create_email_token
    #self.email_token = SecureRandom.urlsafe_base64
    self.email_token = SecureRandom.base64.tr("+/", "-_")
  end

end
