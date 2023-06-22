class Topic < ApplicationRecord
  validates :user_id, presence: true
  validates :body, presence: true
  validates :image, presence: true
  
  mount_uploader :image, ImageUploader
  
  belongs_to :user
  belongs_to :festival
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: 'user'
  has_many :comments
  
  #def user
    #インスタンスメソッド内でselfはインスタンス自身を指す。
    #return Topic.find_by(id: self.id)
  #end
  
end
