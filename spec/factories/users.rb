FactoryBot.define do
    factory :user do
        sequence(:name) { |n| "Test User #{n}" }
        sequence(:email) { |n| "test_#{n}@example.com" }
        sequence(:uid) { |n| "uid_#{n}" }
        google_image_url { 'https://example.com/test_image.jpg' }
        provider { "google_oauth2" }
    end
end
