class Festival < ApplicationRecord
  has_many :topics
  has_many :gones
  
  mount_uploader :logo, ImageUploader
  
  has_many :gones
  has_many :gone_users, through: :gones, source: 'user'
  has_many :wantgos
  has_many :wantgo_users, through: :wantgos, source: 'user'
  
end
