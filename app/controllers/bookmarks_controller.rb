class BookmarksController < ApplicationController

  def create
    board = Board.find(params[:board_id])
    current_user.bookmark(board)
    redirect_back fallback_location: boards_path, success: t('defaults.message.bookmark')
  end

  def destroy
    board = current_user.bookmarks.find(params[:id]).board
    current_user.unbookmark(board)
    redirect_back fallback_location: boards_path, success: t('defaults.message.unbookmark')
  end
end
