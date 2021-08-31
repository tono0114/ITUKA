class Post < ApplicationRecord

  belongs_to :user
  has_many :post_comments
  has_many :favorites

  mount_uploader :image_id, PostImageUploader
end
