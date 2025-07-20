FactoryBot.define do
    factory :user do
        sequence(:name) { |n| "Test User #{n}" }
        sequence(:email) { |n| "test_#{n}@example.com" }
        sequence(:uid) { |n| "uid_#{n}" }
        provider { "test_provider" }
    end
end
