class Topic < ApplicationRecord
  validates :user_id, presence: true
  validates :body, presence: true
  validates :image, presence: true
  
  belongs_to :user
  
  mount_uploader :image, ImageUploader
end
