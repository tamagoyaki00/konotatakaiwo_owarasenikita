Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
end
# OmniAuthの基本設定
OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true


# OmniAuthのログをRailsのロガーに出力する
OmniAuth.config.logger = Rails.logger


# 環境ごとにfull_hostを設定
if Rails.env.production?
  OmniAuth.config.full_host = ENV["RAILS_HOST"] || "https://konotatakaiwo-owarasenikita.onrender.com"
elsif Rails.env.staging?
  OmniAuth.config.full_host = ENV["RAILS_HOST"] || "https://staging-konotatakaiwo-owarasenikita.onrender.com"
else # 開発環境およびテスト環境ではデフォルト値を設定
  OmniAuth.config.full_host = "http://localhost:3000"
end

OmniAuth.config.on_failure = Proc.new do |env|
  error_type = env['omniauth.error.type']
  error_message = env['omniauth.error'].message if env['omniauth.error']
  error_backtrace = env['omniauth.error'].backtrace.first(10).join("\n") if env['omniauth.error']

  Rails.logger.error "🔥🔥🔥 OmniAuth FAILURE - Type: #{error_type}"
  Rails.logger.error "🔥🔥🔥 OmniAuth FAILURE - Message: #{error_message}"
  Rails.logger.error "🔥🔥🔥 OmniAuth FAILURE - Backtrace:\n#{error_backtrace}" if error_backtrace

  # 失敗時のルーティングにリダイレクト
  # これは OmniAuth::FailureEndpoint がデフォルトで /auth/failure にリダイレクトします
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end