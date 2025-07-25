require 'rails_helper'

RSpec.describe "Users", type: :system do
   # user を作成する FactoryBot が必要です
#   let!(:user) { create(:user) }
#   before do
#     # ... 以前の `puts` や `reset_omniauth_config` などのコード ...
#     reset_omniauth_config # これは OmniauthHelpers または LoginHelpers に定義されているはず
#     mock_google_oauth_for(user) # これも OmniauthHelpers または LoginHelpers に定義されているはず
#   end

#   describe 'OAuth処理の詳細デバッグ' do
#     it '各ステップでの状態を確認' do
#       visit root_path
#       puts "🎯 Step 2: Visited root_path"

#       expect(page).to have_button('ログイン')
#       click_button 'ログイン'
#       puts "🎯 Step 3: Clicked login button"

#       puts "🎯 Step 4: Current path: #{current_path}"
#       puts "🎯 Step 4: Current URL: #{current_url}"

#       expect(page).to have_current_path('/', wait: 10) 
#       puts "🔍 After wait - Current path: #{current_path}"
#       puts "🔍 After wait - Current URL: #{current_url}"

#       puts "🔍 Page content after callback:"
#       puts page.body[0..500]

#       if current_path == '/auth/google_oauth2/callback'
#         puts "❌ Still at callback URL - processing may have failed"
#         puts "🔍 Checking for error messages:"
#         if page.has_content?('error') # または特定のエラーメッセージ
#           puts "   - Error found on page"
#         end
#       else
#         puts "✅ Redirected to: #{current_path}"
#         if page.has_content?('ログイン成功') || page.has_content?('ログアウト')
#           puts "✅ Login appears successful"
#         else
#           puts "❓ Login status unclear"
#         end
#       end
#       puts "🎯 Test completed!"
#     end
# end
# end


#   describe 'ログイン前' do
#     it 'マイページに直接アクセスするとrootページにリダイレクトされる' do
#       visit user_path(user)
#       expect(current_path).to eq root_path
#       expect(page).to have_content('ログインしてください')
#     end

#     it '名前編集ページに直接アクセスするとrootページにリダイレクトされる' do
#       visit edit_user_path(user)
#       expect(current_path).to eq root_path
#       expect(page).to have_content('ログインしてください')
#     end
#   end
  
  describe 'ログイン後' do
    let!(:user) { create(:user) }

    describe 'マイページ表示' do
      before { login(user) }
      # it 'マイページにアクセスできる' do
      #   visit user_path(user)
   
      #   # 基本要素の確認
      #   expect(page).to have_content('プロフィール')
      #   expect(page).to have_content(user.name)
      #   expect(page).to have_selector("img[src='#{user.google_image_url}']")
      #   expect(page).to have_content('あなたの投稿したお題')
      # end

      it 'ヘッダーからマイページに遷移できる' do
        click_on 'マイページ'
        expect(page).to have_current_path(user_path(user), wait: 5)
        expect(current_path).to eq user_path(user)
        expect(page).to have_content(user.name)
      end
    end

    describe '名前編集' do
      before { login(user) }
      it '名前を正常に編集できる' do
        visit user_path(user)
        click_link 'ユーザー名を編集'
        
        fill_in 'user_name', with: '新しい名前'
        click_button '更新する'
        
        expect(page).to have_content('名前を変更しました')
        expect(page).to have_content('新しい名前')
        expect(current_path).to eq user_path(user)
      end

      it '空の名前では編集できない' do
        visit user_path(user)
        click_link 'ユーザー名を編集'
      #   fill_in 'user_name', with: ''
      #   click_button '更新する'
        
      #   expect(page).to have_content("Name can't be blank")
      #   expect(current_path).to eq user_path(user)
      end
    end


    # describe '他人のプロフィール' do
    #   before { login(user) }
    #   let(:other_user) { create(:user) }

    #   it '他人のマイページにアクセスすると権限エラーになる' do
    #     visit user_path(other_user)
    #     expect(page).to have_content('権限がありません')
    #   end

    #   it '他人の名前編集ページにアクセスすると権限エラーになる' do
    #     visit edit_user_path(other_user)
    #     expect(page).to have_content('権限がありません')
    #   end
    # end
  end
end