class Post < ActiveRecord::Base
  belongs_to :user
  scope :following, ->(followers) { where user_id: followers }
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
##Default
  default_scope -> { order(created_at: :desc)}
end
