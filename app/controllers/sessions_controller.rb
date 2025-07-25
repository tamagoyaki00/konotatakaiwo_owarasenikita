class SessionsController < ApplicationController
      skip_before_action :require_login, only: [:create, :failure]
  def create
 

    Rails.logger.debug "✨ SessionsController#create: Start processing OAuth callback"
    Rails.logger.debug "  - OmniAuth Auth Hash received: #{request.env['omniauth.auth'].inspect}"

    begin
      auth = request.env['omniauth.auth']
      user = User.find_or_create_from_omniauth(auth)

      if user.persisted?
        session[:user_id] = user.id
        Rails.logger.debug "✅ User (ID: #{user.id}) successfully logged in and session set."
        redirect_to root_path, notice: 'ログインしました。'
      else
        Rails.logger.debug "❌ User creation/find failed. User object: #{user.inspect}, Errors: #{user.errors.full_messages.join(', ')}"
        redirect_to root_path, alert: 'ログインに失敗しました。ユーザー情報の保存に問題がありました。'
      end
    rescue => e
      Rails.logger.error "🔥 SessionsController#create: An unexpected error occurred during auth processing: #{e.class} - #{e.message}"
      Rails.logger.error "  Backtrace:"
      Rails.logger.error e.backtrace.first(15).join("\n  ")
      redirect_to root_path, alert: 'ログイン中に予期せぬエラーが発生しました。'
    end
  end

  def failure
    Rails.logger.error "❌ SessionsController#failure: OmniAuth authentication failed. Message: #{params[:message]}"
    redirect_to root_path, alert: "認証に失敗しました: #{params[:message]}"
  end
end