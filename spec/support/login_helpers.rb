module LoginHelpers
  def login(user)
    mock_google_oauth_for(user)
    visit root_path
    click_on 'ログイン'
    expect(page).to have_content('Google アカウントでログインしました')
  end
end
