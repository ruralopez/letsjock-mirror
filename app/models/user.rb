class User < ActiveRecord::Base
  attr_accessible :email, :lastname, :name, :password, :password_confirmation

  before_save { |user| user.email = email.downcase}
  before_save :create_remember_token

  has_secure_password

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL}, uniqueness: { case_sensitive: false}
  validates :password, presence: true, length: { minimum: 6 }


  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
