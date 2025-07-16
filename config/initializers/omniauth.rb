Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
end
OmniAuth.config.logger = Rails.logger

# 環境ごとにfull_hostを設定
if Rails.env.production?
  # 本番環境のドメインを設定
  OmniAuth.config.full_host = ENV['RAILS_HOST'] || 'https://konotatakaiwo-owarasenikita.onrender.com'
elsif Rails.env.staging?
  # ステージング環境のドメインを設定
  OmniAuth.config.full_host = ENV['RAILS_HOST'] || 'https://staging-konotatakaiwo-owarasenikita.onrender.com'
else
  # 開発環境のドメインを設定
  OmniAuth.config.full_host = 'http://localhost:3000'
end
