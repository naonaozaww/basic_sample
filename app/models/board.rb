class Board < ApplicationRecord
  mount_uploader :board_image, ImageUploader
  belongs_to :user
  has_many :comments, dependent: :destroy
  # board側からbookmarkを通してuserを参照することはない
  has_many :bookmarks, dependent: :destroy
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  private

  def self.ransackable_attributes(auth_abject = nil)
    %w[title body]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
