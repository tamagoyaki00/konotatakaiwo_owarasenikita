require 'rails_helper'

RSpec.describe 'OpinionReactions', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:opinion) { create(:opinion, user: user, question: question) }

  describe 'ログイン前' do
    it 'それなボタンが表示されない、またはクリックできない' do
      visit question_path(question)

      expect(page).not_to have_css('fa-solid fa-thumbs-up')
    end
  end

  describe 'ログイン後' do
    before { login(user) }

    context 'まだリアクションしていない場合' do
      it 'それなボタンをクリックするとリアクションが追加される' do
        visit question_path(question)

        expect {
           find('.fa-solid.fa-thumbs-up').click
        sleep 0.5
        }.to change(OpinionReaction, :count).by(1)

        expect(page).to have_content('1')
        expect(page).to have_css('.reaction-button.active')
        expect(page).to have_content('それな！を取り消す')
      end

      it 'データベースに正しくリアクションが保存される' do
        visit question_path(question)
        find('.fa-solid.fa-thumbs-up').click
        sleep 0.5

        reaction = OpinionReaction.last
        expect(reaction.user).to eq user
        expect(reaction.opinion).to eq opinion
      end
    end

    context '既にリアクションしている場合' do
      before do
        create(:opinion_reaction, user: user, opinion: opinion)
      end

      it 'それなボタンをクリックするとリアクションが解除される' do
        visit question_path(question)

        expect {
          find('.fa-solid.fa-thumbs-up').click
          sleep 0.5
        }.to change(OpinionReaction, :count).by(-1)

        expect(page).to have_content('0')
        expect(page).to have_css('.reaction-button:not(.active)')
        expect(page).to have_content('それな！')
      end
    end

    context '複数のユーザーがリアクションする場合' do
      it '正しいカウント数が表示される' do
        create_list(:opinion_reaction, 3, opinion: opinion)
        visit question_path(question)

        expect(page).to have_content('3')
        find('.fa-solid.fa-thumbs-up').click

        expect(page).to have_content('4')
      end
    end
  end

  describe 'リアクション制限' do
    before { login(user) }

    it '同じユーザーが同じ意見に複数回リアクションできない' do
      visit question_path(question)

      find('.fa-solid.fa-thumbs-up').click
      sleep 0.5

      expect(OpinionReaction.where(user: user, opinion: opinion).count).to eq 1
      expect(page).to have_content('それな！を取り消す')
    end
  end
end
