require 'rails_helper'

RSpec.describe 'Votes', type: :system do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, :with_options, options_count: 2) }

  describe 'ログイン前' do
    before { visit question_path(question) }

    it '投票ボタンがなく、選択肢とログインを促すメッセージが表示されること' do
      expect(page).to have_no_button question.options.first.content
      expect(page).to have_no_button question.options.last.content
      expect(page).to have_no_selector "input[type='submit'][value*='投票']"
      expect(page).to have_content question.options.first.content
      expect(page).to have_content question.options.last.content
      expect(page).to have_content '投票するにはログインが必要です'
    end
  end

  describe 'ログイン後' do
    before do
        login(user)
        visit question_path(question)
    end

    it 'ユーザーが投票し、結果が表示されるまでの一連の流れが正しく動作すること' do
        expect(page).to have_button question.options.first.content
        expect(page).to have_button question.options.last.content

        click_button question.options.first.content
        expect(page).to have_content('投票が完了しました')
        expect(page).to have_content('投票をやり直す')
        expect(page).to have_content('このお題は投票済みです')
        expect(page).to have_content("#{question.options.first.votes_count}票")

        accept_confirm do
            click_button '投票をやり直す'
        end
        expect(page).to have_button question.options.first.content
        expect(page).to have_button question.options.last.content
        expect(page).to have_content('投票を取り消しました')
    end
  end
end
