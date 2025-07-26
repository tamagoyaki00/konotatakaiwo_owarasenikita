class UsersController < ApplicationController
  before_action :set_user
  before_action :correct_user, only: %i[ show edit update ]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash.now[:notice] = "名前を変更しました"
    else
      respond_to do |format|
      # 通常のHTMLリクエストの場合 (例: JS無効時や直接フォーム送信された場合)
      format.html { render :edit, status: :unprocessable_entity }

      # Turbo Stream リクエストの場合 (フォーム送信がTurbo経由の場合)
      format.turbo_stream do
        # エラーメッセージを持つフォームを、user_profile_frame に置き換える
        render turbo_stream: turbo_stream.replace(
          "user_profile_frame", # ターゲットとなるTurbo FrameのID
          partial: "users/form", # フォームのパーシャル
          locals: { user: @user } # エラー情報を持つ @user を渡す
        ), status: :unprocessable_entity
      end
      end
    end
  end

  private

  def set_user
    @user = current_user
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
