class Post < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy

  validates :user_id, {presence: true}
  validates :body, {presence: true}

  def favorited?(user)
    favorites.where(user_id: user.id).exists?
  end
 
end
