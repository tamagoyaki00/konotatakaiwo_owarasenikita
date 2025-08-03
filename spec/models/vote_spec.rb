require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:question) { create(:question) }
  let(:option1) { create(:option, question: question) }
  let(:option2) { create(:option, question: question) }    

  describe 'バリデーション' do
    it 'use_idとoption_idがあれば有効であること' do
      vote = build(:vote, user: user, option: option1)
      expect(vote).to be_valid
    end
  

    it 'user_idがないと無効であること' do
      vote = build(:vote, user: nil, option: option1)
      expect(vote).to be_invalid
      expect(vote.errors.full_messages).to include('ログインしてください')
    end

    it 'option_idがないと無効であること' do
      vote = build(:vote, user: user, option: nil)
      expect(vote).to be_invalid
      expect(vote.errors.full_messages).to include('選択肢を選んでください')
    end

    it '同じユーザーが同じ選択肢に複数回投票はできないこと' do
      create(:vote, user: user, option: option1)
      duplicate_vote = build(:vote, user: user, option: option1)
      expect(duplicate_vote).to be_invalid
      expect(duplicate_vote.errors.full_messages).to include('このお題は既に解答済みです')
    end

    it '同じユーザーが同じお題の別の選択肢に投票しようとすると無効であること' do
      create(:vote, user: user, option: option1)
      second_vote = build(:vote, user: user, option: option2)
      expect(second_vote).to be_invalid
      expect(second_vote.errors.full_messages).to include('このお題は既に解答済みです')
    end


  end
end