require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  # questionを使用する場合は定義が必要
  # let(:question) { create(:question, user: user) }

  describe 'ログイン前' do
    it 'マイページに直接アクセスするとrootページにリダイレクトされる' do
      visit user_path(user)
      expect(current_path).to eq root_path
      expect(page).to have_content('ログインしてください')
    end

    it '名前編集ページに直接アクセスするとrootページにリダイレクトされる' do
      visit edit_user_path(user)
      expect(current_path).to eq root_path
      expect(page).to have_content('ログインしてください')
    end
  end
  
  describe 'ログイン後' do
    before { login(user) }

    describe 'マイページ表示' do
      it 'マイページにアクセスできる' do
        visit user_path(user)
        expect(page).to have_css("img[src='#{user.google_image_url}']")
        expect(page).to have_content(user.name)
        expect(page).to have_link('名前を編集')
        # questionの行をコメントアウト
        # expect(page).to have_content(question.title)
      end

      it 'ヘッダーからマイページに遷移できる' do
        visit root_path
        click_link 'マイページ'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content(user.name)
      end
    end

    describe '名前編集' do
      it '名前を正常に編集できる' do
        visit user_path(user)
        click_link '名前を編集'
        
        fill_in 'user_name', with: '新しい名前'
        click_button '更新する'
        
        expect(page).to have_content('名前を変更しました')
        expect(page).to have_content('新しい名前')
        expect(current_path).to eq user_path(user)
      end

      it '空の名前では編集できない' do
        visit edit_user_path(user)
        fill_in 'user_name', with: ''
        click_button '更新する'
        
        expect(page).to have_content("Name can't be blank")
        expect(current_path).to eq user_path(user)
      end
    end

    describe '他人のプロフィール' do
      let(:other_user) { create(:user) }

      it '他人のマイページにアクセスすると権限エラーになる' do
        visit user_path(other_user)
        expect(page).to have_content('権限がありません')
      end

      it '他人の名前編集ページにアクセスすると権限エラーになる' do
        visit edit_user_path(other_user)
        expect(page).to have_content('権限がありません')
      end
    end
  end
end