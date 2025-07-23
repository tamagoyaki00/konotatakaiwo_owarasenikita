class User < ApplicationRecord
  has_many :questions

  validates :name, presence: true
  validates :email, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.google_image_url = auth.info.image
    end
  end
end
