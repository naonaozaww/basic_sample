class Board < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  # board側からbookmarkを通してuserを参照することはない
  has_many :bookmarks, dependent: :destroy
  mount_uploader :board_image, ImageUploader
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
end
