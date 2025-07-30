require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ログイン前' do
    let!(:user) { create(:user) }
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
    let!(:user) { create(:user) }

    describe 'マイページ表示' do
      before { login(user) }
      it 'マイページにアクセスできる' do
        visit user_path(user)

        expect(page).to have_content('プロフィール')
        expect(page).to have_content(user.name)
        expect(page).to have_selector("img[src='#{user.google_image_url}']")
        expect(page).to have_content('あなたの投稿したお題')
      end

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
        fill_in 'user_name', with: ''
        click_button '更新する'

        expect(page).to have_content("名前を入力してください")
        expect(current_path).to eq user_path(user)
      end
    end


    describe '他人のプロフィール' do
      before { login(user) }
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
