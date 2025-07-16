class SessionsController < ApplicationController
  def omniauth
    redirect_to "/auth/#{params[:provider]}"
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)

    if user.persisted? # ユーザーがデータベースに保存されたか（新規作成 or 既存ユーザー）
      session[:user_id] = user.id
      flash[:notice] = "Googleログインに成功しました。"
      redirect_to root_path
    else
      flash[:alert] = "ユーザーの作成またはログインに失敗しました。"
      redirect_to root_path
    end
  rescue => e
    redirect_to root_path, alert: "認証処理中にエラーが発生しました。"
  end


  def failure
    flash[:alert] = "認証に失敗しました。理由: #{params[:message].humanize}"
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
