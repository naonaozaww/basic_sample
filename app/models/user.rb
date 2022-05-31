class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  # has_many :メソッド, through: :中間テーブル, source: :必要な情報元
  # sourceはメソッドとモデルが異なる場合に必要となる
  has_many :bookmark_boards, through: :bookmarks, source: :board

  validates :last_name, presence: true, length: { maximum: 255 }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, presence: true, uniqueness: true

  def own?(object)
    id == object.user_id
  end

  def bookmark?(board)
    bookmark_boards.include?(board)
    #board.bookmarks.pluck(:user_id).include?(id)
  end

  def bookmark(board)
    bookmark_boards << board
  end

  def unbookmark(board)
    bookmark_boards.destroy(board)
  end
end
