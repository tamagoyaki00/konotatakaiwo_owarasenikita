require 'rails_helper'

RSpec.describe Opinion, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context '全ての属性が有効な場合' do
      it '意見が有効であること' do
        opinion = build(:opinion, user: user, question: question, content: 'テスト意見')
        expect(opinion).to be_valid
      end
    end

    context 'user_idがない場合' do
      it '意見が無効であること' do
        opinion = build(:opinion, user: nil, question: question, content: 'テスト意見')
        expect(opinion).to be_invalid
        expect(opinion.errors[:user]).to include('を入力してください')
      end
    end

    context 'question_idがない場合' do
      it '意見が無効であること' do
        opinion = build(:opinion, user: user, question: nil, content: 'テスト意見')
        expect(opinion).to be_invalid
        expect(opinion.errors[:question]).to include('を入力してください')
      end
    end

    context 'contentがない場合' do
      it '意見が無効であること' do
        opinion = build(:opinion, user: user, question: question, content: '')
        expect(opinion).to be_invalid
        expect(opinion.errors[:content]).to include('を入力してください')
      end
    end

    context 'contentが250文字以内の場合' do
      it '意見が有効であること' do
        opinion = build(:opinion, user: user, question: question, content: 'a' * 250)
        expect(opinion).to be_valid
      end
    end

    context 'contentが251文字以上の場合' do
      it '意見が無効であること' do
        opinion = build(:opinion, user: user, question: question, content: 'a' * 251)
        expect(opinion).to be_invalid
        expect(opinion.errors[:content]).to include('は250文字以内で入力してください')
      end
    end
  end
end
