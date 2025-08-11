FactoryBot.define do
  factory :opinion_reaction do
    association :user
    association :opinion
  end
end