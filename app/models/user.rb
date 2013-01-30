class User < ActiveRecord::Base
  has_many :user_sports, :dependent => :destroy
  has_many :sports, :through => :user_sports

  has_many :competitions, :dependent => :destroy
  has_many :recognitions, :dependent => :destroy
  has_many :results, :dependent => :destroy
  has_many :teams, :dependent => :destroy
  has_many :trains, :dependent => :destroy

  has_many :photos, :dependent => :destroy
  has_many :videos, :dependent => :destroy

  has_many :user_events, :dependent => :destroy
  has_many :events, :through => :user_events

  attr_accessible :email, :lastname, :name, :password, :password_confirmation, :gender, :birth, :citybirth, :country, :phone, :resume, :height, :weight

  before_save { |user| user.email = email.downcase}
  before_create :create_remember_token

  has_secure_password

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL}, uniqueness: { case_sensitive: false}
  validates :password, :presence =>true, :confirmation => true, :length => { :minimum => 6 }, :on => :create
  validates :password, :confirmation => true, :length => { :minimum => 6 }, :on => :update, :unless => lambda{ |user| user.password.blank? }


  def full_name
    name + lastname
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
