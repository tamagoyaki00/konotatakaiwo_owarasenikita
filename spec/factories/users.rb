FactoryBot.define do
    factory :user do
        sequence(:name) { |n| "Test User #{n}" }
        sequence(:email) { |n| "test_#{n}@example.com" }
        sequence(:uid) { |n| "uid_#{n}" }
        sequence(:google_image_url) { |n| "https://lh3.googleusercontent.com/test_image_#{n}.jpg"}
        provider { "google_oauth2" }
    end
end
