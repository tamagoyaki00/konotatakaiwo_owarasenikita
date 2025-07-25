module LoginHelpers

  def login(user)
    mock_google_oauth_for(user)
    visit root_path
    click_button 'ログイン'
    expect(page).to have_content('ログインしました。')
  end
end