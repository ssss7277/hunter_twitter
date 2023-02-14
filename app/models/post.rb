class Post < ApplicationRecord
  validates :user_id, {presence: true}
  validates :body, {presence: true}
end
