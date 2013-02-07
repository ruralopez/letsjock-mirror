class User < ActiveRecord::Base
  has_many :user_sports, :dependent => :destroy
  has_many :sports, :through => :user_sports

  has_many :educations, :dependent => :destroy
  has_many :outcomes
  has_many :exams, :through => :outcomes

  has_many :relationships, foreign_key: "follower_id", :dependent => :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name:  "Relationship", :dependent => :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

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

  has_many :messages

  attr_accessible :email, :lastname, :name, :password, :password_confirmation, :gender, :birth, :citybirth, :country, :phone, :resume, :height, :weight, :profilephotourl

  before_save :profilepic
  before_save { |user| user.email = email.downcase}
  before_create :create_remember_token

  has_secure_password

  validates :name, presence: true
  validates :lastname, presence: true
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL}, uniqueness: { case_sensitive: false}
  validates :password, :presence =>true, :confirmation => true, :length => { :minimum => 6 }, :on => :create
  validates :password, :confirmation => true, :length => { :minimum => 6 }, :on => :update, :unless => lambda{ |user| user.password.blank? }


  def full_name
    name + " " + lastname
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.first(:conditions => ["followed_id = ?", other_user.id]).destroy
  end

  def profilepic
    self.profilephotourl ||= "default-profile.png"
  end

  def last_message_with(user)
    Message.last(:conditions => ["(user_id = ? AND receiver_id = ?) OR (user_id = ? AND receiver_id = ?)", user.id, self.id, self.id, user.id])
  end

  def messages_with(user)
    Message.all(:conditions => ["(user_id = ? AND receiver_id = ?) OR (user_id = ? AND receiver_id = ?)", user.id, self.id, self.id, user.id])
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
