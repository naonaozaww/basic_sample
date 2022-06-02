class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
      # コメントが保存できた場合は入力欄を戻してコメントを表示する
      # 保存に失敗した場合は失敗コメントを挿入して表示する
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_update_params)
      render json: { comment: @comment }, status: :ok
    else
      render json: { comment: @comment, errors: { messages: @comment.errors.full_messages } }, status: :bad_request
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    # 削除したら表示をなくす/失敗は破壊的メソッドでエラーハンドリング
    # @comment.destroyをしても@commentの中身はまだ消えていないので使える(DBからは削除されている)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(board_id: params[:board_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body)
  end
end
