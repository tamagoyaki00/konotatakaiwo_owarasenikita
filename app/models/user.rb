class User < ApplicationRecord
  has_many :questions

  validates :name, presence: true
  validates :email, presence: true
  validates :uid, uniqueness: { scope: :provider }

 def self.find_or_create_from_omniauth(auth)
    # テスト環境でのデバッグ
    if Rails.env.test?
      puts "🔍 User.from_omniauth called"
      puts "  - Auth provider: #{auth&.provider}"
      puts "  - Auth uid: #{auth&.uid}"
      puts "  - Auth info name: #{auth&.info&.name}"
      puts "  - Auth info email: #{auth&.info&.email}"
    end
    
    # 既存ユーザーを検索
    user = where(uid: auth.uid, provider: auth.provider).first
    
    if Rails.env.test?
      puts "  - Found existing user: #{user&.id}"
    end
    
    # ユーザーが見つからない場合は作成
    unless user
      user = create(
        uid: auth.uid,
        provider: auth.provider,
        name: auth.info.name,
        email: auth.info.email,
        google_image_url: auth.info.image
      )
      
      if Rails.env.test?
        puts "  - Created new user: #{user&.id}"
        puts "  - User valid?: #{user&.valid?}"
        puts "  - User errors: #{user&.errors&.full_messages}"
      end
    end
    
    user
  end
end
