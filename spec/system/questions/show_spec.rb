require 'rails_helper'

RSpec.describe "Questions show page", type: :system do
  let!(:user)  { create(:user) }
  let!(:question) { create(:question, :with_options, user: user) }

  describe 'お題詳細ページの表示' do
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
end
