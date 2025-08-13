class SessionsController < ApplicationController
  def destroy
    sign_out current_user
    redirect_to root_path, notice: "ログアウトしました"
  end
end
