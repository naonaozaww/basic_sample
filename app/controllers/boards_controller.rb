class BoardsController < ApplicationController
  before_action :set_current_user_board, only: %i[edit update destroy]

  def index
    @boards = Board.all.includes([:user, :bookmarks]).order(created_at: :desc)
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to boards_path, success: t('defaults.message.create', item: Board.model_name.human)
    else
      flash.now[:danger] = t('defaults.message.not_create', item: Board.model_name.human)
      render :new
    end
  end

  def edit; end

  def update
    if @board.update(board_params)
      redirect_to @board, success: t('defaults.message.update', item: Board.model_name.human)
    else
      flash.now[:danger] = t('defaults.message.not_update', item: Board.model_name.human)
      render :edit
    end
  end

  def show
    @board = Board.find(params[:id])
    @comment = Comment.new
    @comments = @board.comments.includes(:user).order(created_at: :desc)
  end

  def destroy
    @board.destroy!
    redirect_to boards_path, success: t('defaults.message.destroy', item: Board.model_name.human)
  end

  def bookmarks
    @bookmark_boards = current_user.bookmark_boards.includes(:user).order(created_at: :desc)
  end

  private

  def board_params
    params.require(:board).permit(:title, :body, :board_image, :board_image_cache)
  end

  def set_current_user_board
    @board = current_user.boards.find(params[:id])
  end
end
