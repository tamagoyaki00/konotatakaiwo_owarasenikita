FactoryBot.define do
    factory :question do
        association :user

        sequence(:title) { |n| "テストタイトル #{n}" }

        trait :with_options do
        transient do
            options_count { 2 }
        end

        after(:create) do |question, evaluator|
        create_list(:option, evaluator.options_count, question: question)
        end
      end
    end
end
