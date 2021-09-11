class Post < ApplicationRecord

  mount_uploader :image_id, PostImageUploader

  belongs_to :user
  has_many :post_comments
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  validates :title, presence: true, length: { in: 1..20 }

  # 既にいいねしているか確認するメソッド
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

end
