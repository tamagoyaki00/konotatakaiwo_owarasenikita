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
      expect(user.errors.full_messages).to include('名前を入力してください')
    end
  end

  describe 'email' do
    it 'emailが存在しない場合、無効であること' do
      user.email = nil
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include('メールアドレスを入力してください')
    end

    it 'emailはユニークであること' do
      duplicate_user = user.dup
      expect(duplicate_user).to be_invalid
      expect(duplicate_user.errors.full_messages).to include('メールアドレスはすでに存在します')
    end
  end

  describe 'uid and provider uniqueness' do
    let!(:auth_user_one) { FactoryBot.create(:user, uid: '12345', provider: 'google') }

    it '同じuidとproviderの組み合わせの場合、無効であること' do
      duplicate_auth_user = auth_user_one.dup
      expect(duplicate_auth_user).to be_invalid
       expect(duplicate_auth_user.errors.full_messages).to include('Uidはすでに存在します')
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

  describe 'avatar' do
    it 'アバター画像が添付されていない場合、有効であること' do
        user.avatar.purge
        expect(user).to be_valid
    end

    context 'アバター画像のフォーマットが正しい場合' do
      it 'JPG形式の画像が添付されていること' do
        file_path = Rails.root.join('spec/fixtures/files/test.jpg')
        user.avatar.attach(io: File.open(file_path), filename: 'test.jpg', content_type: 'image/jpeg')
        expect(user).to be_valid
      end

      it 'PNG形式の画像が添付されていること' do
        file_path = Rails.root.join('spec/fixtures/files/test.png')
        user.avatar.attach(io: File.open(file_path), filename: 'test.png', content_type: 'image/png')
        expect(user).to be_valid
      end

      it 'GIF形式の画像が添付されていること' do
        file_path = Rails.root.join('spec/fixtures/files/test.gif')
        user.avatar.attach(io: File.open(file_path), filename: 'test.gif', content_type: 'image/gif')
        expect(user).to be_valid
      end
    end

    context 'アバター画像のフォーマットが正しくない場合' do
      it 'エラーを返すこと' do
        file_path = Rails.root.join('spec/fixtures/files/test.txt')
        user.avatar.attach(io: File.open(file_path), filename: 'test.txt', content_type: 'text/plain')
        expect(user).to_not be_valid
        expect(user.errors[:image]).to include("：ファイル形式が、JPEG, PNG, GIF以外になってます。ファイル形式をご確認ください")
      end
    end

    context 'アバター画像のサイズが適切である場合' do
      it '5MB以下の画像が添付されていること' do
        file_path = Rails.root.join('spec/fixtures/files/5mb_test.jpeg')
        user.avatar.attach(io: File.open(file_path), filename: '5mb_test.jpeg', content_type: 'image/jpeg')
        expect(user).to be_valid
      end
    end

    it '5MBを超える画像が添付されている場合、無効であること' do
      file_path = Rails.root.join('spec/fixtures/files/6mb_test.jpeg')
      user.avatar.attach(io: File.open(file_path), filename: '6mb_test.jpeg', content_type: 'image/jpeg')
      expect(user).to_not be_valid
      expect(user.errors[:avatar]).to include("のファイルサイズは5MB以内にしてください")
    end
  end
end
