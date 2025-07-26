module OmniauthHelpers
  def mock_google_oauth_for(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.logger = Rails.logger if Rails.env.test?
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: user.uid,
      info: {
        name: user.name,
        email: user.email,
        image: user.google_image_url
      },
      credentials: {
        token: 'mock_token',
        refresh_token: 'mock_refresh_token'
      }
    })
  end

  def reset_omniauth_config
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end
end
