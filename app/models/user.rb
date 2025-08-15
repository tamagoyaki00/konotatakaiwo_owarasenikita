class User < ApplicationRecord
  devise :database_authenticatable, :rememberable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :questions
  has_many :votes
  has_many :opinions, dependent: :destroy
  has_many :opinion_reactions, dependent: :destroy
  has_many :liked_opinions, through: :opinion_reactions, source: :opinion
  has_one_attached :avatar

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :uid, uniqueness: { scope: :provider }
  validates :image_content_type
  validates :avatar_size


  def image_content_type
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:image, '：ファイル形式が、JPEG, PNG, GIF以外になってます。ファイル形式をご確認ください。')
    end
  end

  def avatar_size
    if avatar.attached? && avatar.byte_size > 5.megabytes
      errors.add(:avatar, 'のファイルサイズは5MB以内にしてください')
    end
  end

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

  def voted?(question)
    votes.joins(:option).exists?(options: { question_id: question.id })
  end

  def voted_option_for(question)
    votes.joins(:option).find_by(options: { question_id: question.id })&.option
  end

  def own?(object)
    id == object&.user_id
  end
end
