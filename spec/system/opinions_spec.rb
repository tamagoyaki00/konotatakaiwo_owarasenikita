require 'rails_helper'

RSpec.describe 'Opinions', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:opinion) { create(:opinion, user: user, question: question) }
  let!(:other_opinion) { create(:opinion, user: other_user, question: question) }

  describe '意見投稿機能' do
    context 'ログインしていない場合' do
      it '意見を投稿できず、ログインが必要なメッセージが表示されること' do
        visit question_path(question)
        expect(page).not_to have_selector('form')
        expect(page).to have_content('意見を投稿するにはログインが必要です')
      end
    end

    context 'ログインしている場合' do
      before do
        login(user)
        visit question_path(question)
      end

      it '意見投稿フォームが表示されること' do
        expect(page).to have_selector('form')
        expect(page).to have_field('opinion[content]')
        expect(page).to have_button '投稿'
      end

      context '無効な意見投稿' do
        it 'contentが空の場合、エラーメッセージが表示されること' do
          fill_in 'opinion[content]', with: ''
          click_button '投稿'

          expect(page).to have_content('意見を入力してください')
        end

        it 'contentが251文字以上の場合、エラーメッセージが表示されること' do
          fill_in 'opinion[content]', with: 'a' * 251
          click_button '投稿'

          expect(page).to have_content('は250文字以内で入力してください')
        end
      end

      context '有効な意見投稿' do
        it '250文字以内の意見を投稿でき、即座に表示されること' do
          opinion_content = 'これは新しい意見です。'

          fill_in 'opinion[content]', with: opinion_content
          click_button '投稿'

          expect(page).to have_content(opinion_content)
          expect(find_field('opinion[content]').value).to be_blank
        end

        it '250文字ちょうどの意見を投稿できること' do
          max_content = 'a' * 250

          fill_in 'opinion[content]', with: max_content
          click_button '投稿'
          expect(page).to have_content(max_content)
        end
      end
    end
  end

  describe '意見表示・権限機能' do
    before do
      login(user)
      visit question_path(question)
    end

    context '自分の投稿', js: true do
      it '自分の意見には編集・削除リンクが表示されること' do
        within("#opinion_#{opinion.id}") do
          expect(page).to have_link '編集'
          expect(page).to have_link '削除'
        end
      end

      it '編集をクリックすると編集フォームが表示されること' do
        within("#opinion_#{opinion.id}") do
          click_link '編集'
        end
        expect(page).to have_button '更新する'
        expect(page).to have_link 'キャンセル'
      end

      it '編集した内容で更新できること' do
        within("#opinion_#{opinion.id}") do
          click_link '編集'
          fill_in 'opinion_content', with: '編集後の意見'
          click_button '更新する'
        end

        expect(page).to have_content('編集後の意見')
        within("#opinion_#{opinion.id}") do
          expect(page).to have_content('編集後の意見')
          expect(page).not_to have_content(opinion.content)
        end
      end

      it 'キャンセルボタンで元の表示に戻ること' do
        within("#opinion_#{opinion.id}") do
          click_link '編集'
          expect(page).to have_link 'キャンセル'
          click_link 'キャンセル'
        end
        expect(page).to have_content(opinion.content)
      end

      it '削除をクリックすると意見が削除されること' do
        within("#opinion_#{opinion.id}") do
          expect(page).to have_link '削除'
          accept_confirm '本当に削除しますか?' do
            click_link '削除'
          end
        end
        expect(page).to have_content('意見が削除されました')
        expect(page).not_to have_selector("#opinion_#{opinion.id}")
     end
    end

    context '他人の投稿' do
      it '他人の意見には編集・削除リンクが表示されないこと' do
        within("#opinion_#{other_opinion.id}") do
          expect(page).to_not have_link '編集'
          expect(page).to_not have_link '削除'
        end
      end

      it '直接URLにアクセスしても編集ページにアクセスできず、権限がない旨のメッセージが表示されること' do
        visit edit_opinion_path(other_opinion)
        expect(page).to have_content('権限がありません')
      end
    end
  end
end
