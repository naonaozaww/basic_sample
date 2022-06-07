class ProfilesController < ApplicationController
  before_action :set_current_user, only: %i[edit update]

  def show; end
  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: t('defaults.message.update', item: User.model_name.human)
    else
      flash.now[:danger] = t('defaults.message.not_update', item: User.model_name.human)
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :frist_name, :last_name, :avatar, :avatar_cache)
  end

  def set_current_user
    @user = User.find(current_user.id)
  end
end
