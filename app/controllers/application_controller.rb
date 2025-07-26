

class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user, :logged_in?

  private

  def current_user
    # @current_user がnilの場合のみDBからユーザーを検索（N+1問題対策）
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end


  def require_login
    unless logged_in?
      flash[:alert] = "ログインしてください。"
      redirect_to root_path
    end
  end
end
