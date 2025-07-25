module SystemTestHelpers
  def login(user)
    puts "🔄 Login Helper 開始 - User ID: #{user.id}"
    
    # テスト用ログインエンドポイントを使用
    visit "/test/login/#{user.id}"
    
    # レスポンス確認（JSON）
    response_body = page.body
    puts "Login endpoint response: #{response_body}"
    
    # ルートページに移動してログイン状態確認
    visit root_path
    logged_in = !page.has_content?('ログインしてください')
    
    puts logged_in ? "✅ Login Helper 成功" : "❌ Login Helper 失敗"
    
    # セッション状態確認
    visit "/test/session_check"
    session_info = page.body
    puts "Session check: #{session_info}"
    
    # 元のページに戻る
    visit root_path
    
    logged_in
  end
  
  def debug_session_info
    puts "=== Session Debug ==="
    puts "Current path: #{current_path}"
    puts "Page title: #{page.title}"
    puts "Has login form: #{page.has_content?('ログイン')}"
    puts "===================="
  end
end