module LoginHelper
  def login(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: user.uid,
      info: {
        name: user.name,
        email: user.email,
        image: user.google_image_url
      }
    })
    
    visit "/auth/google_oauth2"
  end
end