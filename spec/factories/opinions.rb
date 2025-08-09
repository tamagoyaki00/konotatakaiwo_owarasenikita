FactoryBot.define do
  factory :opinion do
    content { "これはテスト用の意見です。" }
    association :user
    association :question

    trait :long_content do
      content { 'a' * 251 }
    end

    trait :max_content do
      content { 'a' * 250 }
    end
  end
end
