class User < ApplicationRecord
  devise :database_authenticatable, :rememberable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :questions
  has_many :votes

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :uid, uniqueness: { scope: :provider }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.provider = auth.provider
      user.uid = auth.uid
      user.google_image_url = auth.info.image
    end
  end

  # パスワード認証を無効にした時、パスワードなしで更新できるようにするため
  def update_without_current_password(params, *options)
    params.delete(:current_password)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    result = update(params, *options)
    clean_up_passwords
    result
  end

  def voted_for?(option)
    votes.exists?(option: option)
  end

  def voted_on_question?(question)
    votes.joins(:option).exists?(options: { question_id: question.id })
  end
end
