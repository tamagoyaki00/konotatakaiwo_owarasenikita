require 'rails_helper'

RSpec.describe "Questions", type: :system do
  describe 'Questions' do
    let!(:user) { create(:user) }

    describe 'GET /index' do
      context '問題が存在する場合' do
        let!(:question1) { create(:question, title: '究極の選択1', user: user) }
        let!(:question2) { create(:question, title: '究極の選択2', user: user) }

        before do
          visit questions_path
        end

        it 'すべての問題が表示される' do
          expect(page).to have_content('究極の選択1')
          expect(page).to have_content('究極の選択2')
        end

        it '問題ごとに、タイトル、作者の名前、アイコンが表示されること' do
          within(".card-animated", text: question1.title) do
            expect(page).to have_content(question1.title)
            expect(page).to have_content("#{question1.user.name}")
            expect(page).to have_selector("img[src='#{question1.user.google_image_url}']")
          end
        end
      end

      context 'お題が存在しない場合' do
        before do
          visit questions_path
        end

        it 'お題はありませんという文字が表示されること' do
          expect(page).to have_content ('お題はありません')
          expect(page).not_to have_selector('.card-animated')
        end
      end
    end

    describe 'GET /new' do
      context 'ログイン前' do
        it 'お題作成画面にアクセスするとrootページにリダイレクトされる' do
          visit new_question_path
          expect(current_path).to eq root_path
          expect(page).to have_content('ログインしてください')
        end
      end

      context 'ログイン後' do
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
            expect(page).to have_button '投稿'
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
              expect(page).to have_content('お題が作成されました')
            end.to change(Question, :count).by(1)
              .and(change(Option, :count).by(2))

            created_question = Question.last
            expect(page).to have_current_path(question_path(created_question))
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

          it '無効なデータの場合、お題も選択肢も作成されない' do
            initial_question_count = Question.count
            initial_option_count = Option.count

            fill_in 'タイトル', with: ''
            fill_in '選択肢1', with: 'テスト1'
            fill_in '選択肢2', with: 'テスト2'
            click_on '投稿'

            expect(Question.count).to eq initial_question_count
            expect(Option.count).to eq initial_option_count

            expect(page).to have_current_path(new_question_path)
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

    describe 'GET /show' do
      let!(:question) { create(:question, :with_options, user: user) }

      context '一覧画面から詳細画面へ移動する場合' do
        it '詳細画面に正しく遷移し、内容が表示されること' do
          visit questions_path
          find(".card-animated", text: question.title).click
          expect(page).to have_content(question.title)
          expect(page).to have_content('どちらか選択してください')
          expect(page).to have_current_path(question_path(question))
          expect(page).to have_content(question.options.first.content)
          expect(page).to have_content(question.options.last.content)
          expect(page).to have_content("#{question.user.name}")
          expect(page).to have_selector("img[src='#{question.user.google_image_url}']")
        end
      end
    end

    describe 'GET /edit' do
      let!(:question) { create(:question, :with_options, user: user) }
      let!(:other_user) { create(:user) }

      context '自分の投稿の場合' do
        before do
            login(user)
            visit question_path(question)
        end

        it '詳細画面から編集ボタンを押すとフォーム画面が表示されること' do
            click_link '編集'
            expect(page).to have_button '更新'
            expect(page).to have_link 'キャンセル'
            expect(page).to have_field('タイトル', with: question.title)
            expect(page).to have_field('選択肢1', with: question.options.first.content)
            expect(page).to have_field('選択肢2', with: question.options.last.content)
        end
      end

        context '他人の投稿の場合' do
            before do
                login(other_user)
                visit question_path(question)
            end

            it '編集ボタンが表示されないこと' do
                expect(page).not_to have_link '編集'
            end
        end
    end

    describe 'PATCH /update' do
      let!(:question) { create(:question, :with_options, user: user) }
      let!(:other_user) { create(:user) }

      context '自分の投稿の場合' do
        before do
            login(user)
            visit edit_question_path(question)
        end

        it '有効な情報で更新した場合、お題が更新され、詳細ページにリダイレクトされること' do
            fill_in 'タイトル', with: '更新されたタイトル'
            fill_in '選択肢1', with: '更新された選択肢1'
            fill_in '選択肢2', with: '更新された選択肢2'
            click_button '更新'
            expect(page).to have_content 'お題が更新されました'
            expect(page).to have_content '更新されたタイトル'
            expect(page).to have_content '更新された選択肢1'
            expect(page).to have_content '更新された選択肢2'
        end
      end

      describe '無効な属性での更新' do
        before do
            login(user)
            visit edit_question_path(question)
        end

        context 'タイトルが空の場合' do
            it 'エラーメッセージ「タイトルを入力してください」が表示されること' do
                fill_in 'タイトル', with: ''
                click_button '更新'
                expect(page).to have_content('タイトルを入力してください')
            end
        end

        context 'タイトルが長すぎる場合' do
            it 'エラーメッセージ「タイトルは29文字以内で入力してください」が表示されること' do
                fill_in 'タイトル', with: 'a' * 30
                click_button '更新'
                expect(page).to have_content('タイトルは29文字以内で入力してください')
            end
        end

        context '選択肢が重複している場合' do
            it 'エラーメッセージ「選択肢は重複しないようにしてください」が表示されること' do
                fill_in '選択肢1', with: '同じ内容'
                fill_in '選択肢2', with: '同じ内容'
                click_button '更新'
                expect(page).to have_content('選択肢は重複しないようにしてください')
            end
        end

        context '選択肢1が空の場合' do
            it 'エラーメッセージ「選択肢1を入力してください」が表示されること' do
                fill_in '選択肢1', with: ''
                click_button '更新'
                expect(page).to have_content('選択肢1を入力してください')
            end
        end

        context '選択肢2が空の場合' do
            it 'エラーメッセージ「選択肢2を入力してください」が表示されること' do
                fill_in '選択肢2', with: ''
                click_button '更新'
                expect(page).to have_content('選択肢2を入力してください')
            end
        end

        context '選択肢1が長すぎる場合' do
            it 'エラーメッセージ「選択肢1は29文字以内で入力してください」が表示されること' do
                fill_in '選択肢1', with: 'a' * 30
                click_button '更新'
                expect(page).to have_content('選択肢1は29文字以内で入力してください')
            end
        end

        context '選択肢2が長すぎる場合' do
            it 'エラーメッセージ「選択肢2は29文字以内で入力してください」が表示されること' do
                fill_in '選択肢2', with: 'a' * 30
                click_button '更新'
                expect(page).to have_content('選択肢2は29文字以内で入力してください')
            end
        end
      end


      context '他人の投稿の場合' do
        before do
            login(other_user)
            visit edit_question_path(question)
        end

        it '編集ページにアクセスできず、ルートページにリダイレクトされること' do
            expect(page).to have_current_path(root_path)
            expect(page).to have_content('権限がありません')
        end
      end
    end

    describe 'DELETE /destroy' do
      let!(:question) { create(:question, :with_options, user: user) }
      let!(:other_user) { create(:user) }

      context '自分の投稿の場合' do
        before do
            login(user)
            visit question_path(question)
        end

        it 'お題が削除され、一覧ページにリダイレクトされること' do
            expect(page).to have_button '削除'
            accept_confirm '本当に削除しますか?' do
              click_on '削除'
            end
            expect(page).to have_current_path(questions_path)
            expect(Question.count).to eq 0
        end
      end

      context '他人の投稿の場合' do
        before do
            login(other_user)
            visit question_path(question)
        end

        it '削除ボタンが表示されないこと' do
            expect(page).not_to have_button '削除'
        end
      end
    end
  end
end
