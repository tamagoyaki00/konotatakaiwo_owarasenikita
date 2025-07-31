require 'rails_helper'

RSpec.describe "Questions index page", type: :system do
  describe '一覧ページの表示' do
    context '問題が存在する場合' do
        let!(:user)  { create(:user) }
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
            expect(page).to have_content 'お題はありません'
            expect(page).not_to have_selector('.card-animated')
        end
    end
  end
end
