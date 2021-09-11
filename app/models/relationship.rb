class Relationship < ApplicationRecord
  
  # 自分をフォローしているユーザー
  belongs_to :follower, class_name: "User"
  
  # 自分がフォローしているユーザー
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true, uniqueness: { scope: :followed_id }
  validates :followed_id, presence: true

end
