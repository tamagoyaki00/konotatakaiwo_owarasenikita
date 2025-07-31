require 'rails_helper'

RSpec.describe "Questions new page", type: :system do
  describe 'ログイン前' do
    let!(:user) { create(:user) }
    it 'お題作成画面にアクセスするとrootページにリダイレクトされる' do
      visit new_question_path
      expect(current_path). to eq root_path
      expect(page).to have_content('ログインしてください')
    end
  end

  describe 'ログイン後' do
    let!(:user) { create(:user) }

    let(:valid_attributes_for_form) do
      {
        title: 'テストタイトル',
        option1_content: '選択肢1の内容',
        option2_content: '選択肢2の内容'
      }
    end

    describe '新規作成ページの表示' do
      before { login(user) }

      it '新規作成ページのアクセスができる' do
        visit new_question_path
        expect(page).to have_content('タイトル')
        expect(page).to have_content('選択肢1')
        expect(page).to have_content('選択肢2')
        expect(page).to have_button('投稿')
      end
    end

    describe '有効な属性での投稿' do
      before do
        login(user)
        visit new_question_path
      end

      it '新しいお題と選択肢が作成され、詳細ページにリダイレクトされること' do
        expect do
          fill_in 'タイトル', with: valid_attributes_for_form[:title]
          fill_in '選択肢1', with: valid_attributes_for_form[:option1_content]
          fill_in '選択肢2', with: valid_attributes_for_form[:option2_content]
          click_button '投稿'
        end.to change(Question, :count).by(1)
          .and change(Option, :count).by(2)

        created_question = Question.last
        expect(page).to have_current_path(question_path)
        expect(page).to have_content('お題を作成しました')
        expect(page).to have_content(valid_attributes_for_form[:title])
        expect(page).to have_content(valid_attributes_for_form[:option1_content])
        expect(page).to have_content(valid_attributes_for_form[:option2_content])
        expect(page).to have_content(user.name)
      end
    end

    describe '無効な属性での投稿' do
      before do
        login(user)
        visit new_question_path
      end

      it '無効なデータの場合、お題も選択肢も作成されず、入力内容が保持されること' do
        expect do
          fill_in 'タイトル', with: ''
          fill_in '選択肢1', with: '入力保持テスト1'
          fill_in '選択肢2', with: '入力保持テスト2'
          click_button '投稿'
        end.to_not change(Question, :count)
          .and(not_change(Option, :count))

        created_question = Question.last
        expect(page).to have_current_path(new_question_path)
        expect(page).to have_content('お題の作成に失敗しました。')
        expect(page).to have_field('タイトル', with: '')
        expect(page).to have_field('選択肢1', with: '入力保持テスト1')
        expect(page).to have_field('選択肢2', with: '入力保持テスト2')
      end

      context 'タイトルが空の場合' do
        it 'エラーメッセージ「タイトルを入力してください」が表示されること' do
          fill_in 'タイトル', with: ''
          fill_in '選択肢1', with: '選択肢1の内容'
          fill_in '選択肢2', with: '選択肢2の内容'
          click_button '投稿'

          expect(page).to have_content('タイトルを入力してください')
        end
      end

      context 'タイトルが長すぎる場合' do
        it 'エラーメッセージ「タイトルは29文字以内で入力してください」が表示されること' do
          fill_in 'タイトル', with: 'a' * 30
          fill_in '選択肢1', with: '選択肢1の内容'
          fill_in '選択肢2', with: '選択肢2の内容'
          click_button '投稿'

          expect(page).to have_content('タイトルは29文字以内で入力してください')
        end
      end

      context '選択肢が重複している場合' do
        it 'エラーメッセージ「選択肢は重複しないようにしてください」が表示されること' do
          fill_in 'タイトル', with: 'テスト'
          fill_in '選択肢1', with: '同じ内容'
          fill_in '選択肢2', with: '同じ内容'
          click_button '投稿'

          expect(page).to have_content('選択肢は重複しないようにしてください')
        end
      end

      context '選択肢1が空の場合' do
        it 'エラーメッセージ「選択肢1を入力してください」が表示されること' do
          fill_in 'タイトル', with: 'テスト'
          fill_in '選択肢1', with: ''
          fill_in '選択肢2', with: 'テスト'
          click_button '投稿'

          expect(page).to have_content('選択肢1を入力してください')
        end
      end

      context '選択肢2が空の場合' do
        it 'エラーメッセージ「選択肢2を入力してください」が表示されること' do
          fill_in 'タイトル', with: 'テスト'
          fill_in '選択肢1', with: 'テスト'
          fill_in '選択肢2', with: ''
          click_button '投稿'

          expect(page).to have_content('選択肢2を入力してください')
        end
      end

      context '選択肢1が長すぎる場合' do
        it 'エラーメッセージ「選択肢1は29文字以内で入力してください」が表示されること' do
          fill_in 'タイトル', with: 'テスト'
          fill_in '選択肢1', with: 'a' * 30
          fill_in '選択肢2', with: 'テスト'
          click_button '投稿'

          expect(page).to have_content('選択肢1は29文字以内で入力してください')
        end
      end

      context '選択肢2が長すぎる場合' do
        it 'エラーメッセージ「選択肢2は29文字以内で入力してください」が表示されること' do
          fill_in 'タイトル', with: 'テスト'
          fill_in '選択肢1', with: 'テスト'
          fill_in '選択肢2', with: 'a' * 30
          click_button '投稿'

          expect(page).to have_content('選択肢2は29文字以内で入力してください')
        end
      end
    end
  end
end