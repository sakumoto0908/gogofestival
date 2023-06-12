class Festival < ApplicationRecord
  has_many :topics
  
  mount_uploader :logo, ImageUploader
end
