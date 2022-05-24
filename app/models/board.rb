class Board < ApplicationRecord
  belongs_to :user
  mount_uploader :board_image, ImageUploader
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
end
