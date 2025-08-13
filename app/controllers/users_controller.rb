class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update]
  before_action :correct_user, only: %i[ show edit update]

def show
  @questions = @user.questions.includes(:user).order(created_at: :desc)
end

  def edit
  end

  def update
    if @user.update(user_params)
      flash.now[:notice] = "名前を変更しました"
    else
      render turbo_stream: turbo_stream.replace(
        "user_profile_frame",
        partial: "users/form",
        locals: { user: @user }
      ), status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    unless @user == current_user
      flash[:alert] = "権限がありません"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
