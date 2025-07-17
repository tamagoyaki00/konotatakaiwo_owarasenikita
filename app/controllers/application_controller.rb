class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in? # ビューでこれらのメソッドを使えるようにする

  private

  def current_user
    # @current_user がnilの場合のみDBからユーザーを検索（N+1問題対策）
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    # current_userが存在すればtrueを返す
    !!current_user
  end

  # ログインが必須なアクションのために、before_actionで使えるメソッド
  def require_login
    unless logged_in?
      flash[:alert] = "ログインしてください。"
      redirect_to root_path # ログインしていない場合はルートにリダイレクト
    end
  end
end
