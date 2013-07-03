class User < ActiveRecord::Base
  default_scope where("authentic_email = 1")
  
  has_many :user_sports, :dependent => :destroy
  has_many :sports, :through => :user_sports

  has_many :sponsors_events, :dependent => :destroy
  has_many :events, :through => :sponsors_events

  has_one :publishers
  has_many :subscriptions
  has_many :activities
  has_many :notifications
  has_many :stats

  has_many :educations, :dependent => :destroy
  has_many :outcomes
  has_many :exams, :through => :outcomes

  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :followed_users, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship", :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  has_many :user_admins, :dependent => :destroy
  has_many :admins, :through => :user_admins, :source => :admin

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
  has_many :likes, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :messages

  attr_accessible :email, :lastname, :name, :password, :password_confirmation, :gender, :birth, :citybirth, :country, :address, :phone, :resume, :height, :weight, :profilephotourl, :authentic_email, :isSponsor, :preferences, :certified

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
  
  def generate_alias
    if self.full_name.split(" ").length > 1
      temp_alias = ""
      
      self.full_name.split(" ").each do |w|
        temp_alias += ActiveSupport::Inflector.transliterate(w.downcase)
      end
      
      return temp_alias
    else
      self.full_name
    end
  end

  def age
    now = Time.now.utc.to_date
    now.year - self.birth.year - (self.birth.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def set_sport(sport_id, category)
    UserSport.delete_all(["user_id = ? AND position = ?", self.id, category.to_s]) if UserSport.exists?(:user_id => self.id, :position => category.to_s)
    UserSport.delete_all(["user_id = ? AND position = ?", self.id, "main"]) if UserSport.exists?(:user_id => self.id, :position => "main")
    if UserSport.exists?(:user_id => self.id, :sport_id => sport_id)
      UserSport.delete_all(["user_id = ? AND sport_id = ?", self.id, sport_id])
    end
    UserSport.new(:user_id => self.id, :sport_id => sport_id, :position => category.to_s).save
  end

  def set_sport_main(sport_id)
    current_main = self.get_sport_id_main
    
    if current_main && current_main != sport_id
      UserSport.delete_all( :user_id => self.id, :position => "main" )
      UserSport.create(:user_id => self.id, :sport_id => current_main)
    end
    
    if UserSport.exists?(:user_id => self.id, :sport_id => sport_id)
      UserSport.delete_all( :user_id => self.id, :sport_id => sport_id)
    end
    
    UserSport.create(:user_id => self.id, :sport_id => sport_id, :position => "main")
  end
  
  def get_sport_id_main
    if UserSport.exists?(:user_id => self.id, :position => "1")
      UserSport.all(:conditions => ["user_id = ? AND position = '1'", self.id]).first.sport_id
    elsif UserSport.exists?(:user_id => self.id, :position => "main")
      UserSport.all(:conditions => ["user_id = ? AND position = 'main'", self.id]).first.sport_id
    else
      nil
    end
  end

  def sport_show
    if self.isSponsor
      "Institution"
    elsif UserSport.exists?(:user_id => self.id, :position => "main")
      Sport.find(UserSport.all(:conditions => ["user_id = ? AND position = 'main'", self.id]).first.sport_id).full_name
    elsif UserSport.exists?(:user_id => self.id, :position => "1")
      Sport.find(UserSport.all(:conditions => ["user_id = ? AND position = '1'", self.id]).first.sport_id).full_name
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
  
  def joined?(event)
    UserEvent.exists?(:user_id => self.id, :event_id => event.id)
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
  
  def new_notifications_count
    Notification.all(:conditions => ["`user_id` = ? AND `read` = 0", self.id]).count
  end
  
  def isAdmin? #Obviamente hay que crear el atributo, pero por mientras
    self.id == 1 # Si es el usuario LetsJock
  end
  
  def inAdmins?(user) # Si un usuario es administrador de otro, para el caso de las instituciones
    user.isAdmin? || UserAdmin.exists?(:user_id => self.id, :admin_id => user.id)
  end
  
  def administerUser
    User.where(:id => UserAdmin.select("user_id").where(:admin_id => self.id) )
  end

  def compare_password(pass)
    self.try(:authenticate, pass)
  end

  def category_in(event)
    if SponsorsEvent.exists?(:user_id => self.id, :event_id => event.id)
      return SponsorsEvent.where(:user_id => self.id, :event_id => event.id).first.category
    else
      return 0
    end
  end

  def tags(global_type)
    iam = []
    if Tags.exists?(:id2 => self.id, :type2 => "User", :type1 => global_type)
      ids = Tags.select("id1").find(:all, :conditions => ["id2 = ? AND type2 = ? AND type1 = ?", self.id, "User", global_type])
      idX = []
      ids.each {|id| idX.push(id.id1)}
      return idX
    end
  end

  def tags?
    return Tags.exists?(:id2 => self.id, :type2 => "User")
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
