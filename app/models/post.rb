class Post < ApplicationRecord

  mount_uploader :image_id, PostImageUploader

  belongs_to :user
  has_many :post_comments
  has_many :favorites
  has_many :favorited_users, through: :favorites, source: :user

end
