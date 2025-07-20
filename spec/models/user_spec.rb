require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it 'バリデーションが有効であること' do
    expect(user).to be_valid
  end

  describe 'name' do
    it 'nameが存在しない場合、無効であること' do
      user.name = nil
      expect(user).to be_invalid
      expect(user.errors[:name]).to be_present
    end
  end

  describe 'email' do
    it 'emailが存在しない場合、無効であること' do
      user.email = nil
      expect(user).to be_invalid
      expect(user.errors[:email]).to be_present
    end

    it 'emailはユニークであること' do
      duplicate_user = user.dup
      expect(duplicate_user).to be_invalid
      expect(duplicate_user.errors[:email]).to be_present
    end
  end

  describe 'uid and provider uniqueness' do
    let!(:auth_user_one) { FactoryBot.create(:user, uid: '12345', provider: 'google') }

    it '同じuidとproviderの組み合わせの場合、無効であること' do
      duplicate_auth_user = auth_user_one.dup
      expect(duplicate_auth_user).to be_invalid
      expect(duplicate_auth_user.errors[:uid]).to be_present
    end

    it 'uidが同じでもproviderが異なる場合、有効であること' do
      user_with_different_provider = FactoryBot.build(:user, uid: auth_user_one.uid, provider: 'facebook')
      expect(user_with_different_provider).to be_valid
    end

    it 'providerが同じでもuidが異なる場合、有効であること' do
      user_with_different_uid = FactoryBot.build(:user, uid: '67890', provider: auth_user_one.provider)
      expect(user_with_different_uid).to be_valid
    end
  end
end
