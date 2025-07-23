class UsersController < ApplicationController
  before_action :require_login
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash.now[:notice] = "名前を変更しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
