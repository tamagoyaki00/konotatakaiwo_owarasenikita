class SessionsController < ApplicationController
      skip_before_action :require_login, only: [ :create, :failure ]
  def create
    begin
      auth = request.env["omniauth.auth"]
      user = User.find_or_create_from_omniauth(auth)

      if user.persisted?
        session[:user_id] = user.id
        redirect_to root_path, notice: "ログインしました。"
      else

        redirect_to root_path, alert: "ログインに失敗しました。ユーザー情報の保存に問題がありました。"
      end
    rescue => e

      redirect_to root_path, alert: "ログイン中に予期せぬエラーが発生しました。"
    end
  end

  def failure
    redirect_to root_path, alert: "認証に失敗しました: #{params[:message]}"
  end
end
