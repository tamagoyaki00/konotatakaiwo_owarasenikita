class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :questions

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :uid, uniqueness: { scope: :provider }

 def self.find_or_create_from_omniauth(auth)
    # 既存ユーザーを検索
    user = where(uid: auth.uid, provider: auth.provider).first

    # ユーザーが見つからない場合は作成
    unless user
      user = create(
        uid: auth.uid,
        provider: auth.provider,
        name: auth.info.name,
        email: auth.info.email,
        google_image_url: auth.info.image
      )
    end

    user
  end
end
