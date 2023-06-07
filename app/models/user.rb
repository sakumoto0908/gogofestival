class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 1, maximum: 15 }
  
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)(?=.*?[\W_])[!-~]{8,}+\z/
  validates :password, presence: true, format: { with: VALID_PASSWORD_REGEX }, length: { minimum: 8, maximum: 24 }
  
  has_secure_password
  
  has_many :topics
  has_many :favorites
  has_many :favorite_topics, through: :favorites, source: 'topic'
  
  #authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader
end
