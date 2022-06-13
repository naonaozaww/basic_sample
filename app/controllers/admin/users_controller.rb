class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), success: t('defaults.message.update', item: User.model_name.human)
    else
      flash.now[:danger] = t('defaults.message.not_update', item: User.model_name.human)
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :email, :avatar, :avatar_cache, :role)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
