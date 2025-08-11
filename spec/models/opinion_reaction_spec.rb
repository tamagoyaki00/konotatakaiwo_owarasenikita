require 'rails_helper'

RSpec.describe OpinionReaction, type: :model do
  describe 'バリデーション' do
    it 'ユーザーと意見があれば有効' do
      reaction = build(:opinion_reaction)
      expect(reaction).to be_valid
    end

    it '同じユーザーが同じ意見に2回以上リアクションできない' do
      user = create(:user)
      opinion = create(:opinion)

      create(:opinion_reaction, user: user, opinion: opinion)
      duplicate = build(:opinion_reaction, user: user, opinion: opinion)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include('はすでに存在します')
    end

    it 'ユーザーがなければ無効' do
      reaction = build(:opinion_reaction, user: nil)
      expect(reaction).not_to be_valid
    end

    it '意見がなければ無効' do
      reaction = build(:opinion_reaction, opinion: nil)
      expect(reaction).not_to be_valid
    end
  end
end
