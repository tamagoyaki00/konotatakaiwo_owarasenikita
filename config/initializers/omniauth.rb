Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
end
OmniAuth.config.logger = Rails.logger
OmniAuth.config.full_host = "http://localhost:3000" # ローカル環境
