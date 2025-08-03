FactoryBot.define do
    factory :vote do
      association :option
      association :user
    end
end