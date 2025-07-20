FactoryBot.define do
    factory :option do
      association :question
      sequence(:content) { |n| "テスト選択肢 #{n}" }
    end
end
