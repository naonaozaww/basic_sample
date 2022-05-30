class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :board

  # user_idとboard_idの組み合わせが一意であるための制約
  validates :user_id, uniqueness: { scope: :board_id }
end
